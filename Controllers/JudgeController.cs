using LMS.API.Data;
using LMS.API.DTOs;
using LMS.API.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Diagnostics;
using System.Text;

namespace LMS.API.Controllers;

/// <summary>
/// Self-hosted code execution engine — no third-party APIs.
/// Compiles and runs student code directly on the server using the language
/// runtimes already installed (python3, g++, javac, node). Each execution
/// runs in a separate OS process with a hard timeout and stdout/stderr capture.
/// Supported: Python 3, C++ (g++), Java (javac/java), JavaScript (node), C (gcc)
/// </summary>
[ApiController, Route("api/judge"), Authorize]
public class JudgeController(LmsDbContext db, ILogger<JudgeController> logger) : ControllerBase
{
    // Execution limits — prevent infinite loops and resource abuse
    const int TimeoutMs = 10_000; // 10 seconds max per run
    const int MaxOutputBytes = 1024 * 64; // 64 KB max output

    // ── Run code against custom input (student clicks "Run") ────
    [HttpPost("run")]
    public async Task<IActionResult> Run([FromBody] RunCodeRequest req)
    {
        try
        {
            var result = await ExecuteCode(req.Code, req.Language, req.Input ?? "");
            return Ok(result);
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "Code execution failed for language {Lang}", req.Language);
            return StatusCode(500, new { message = "Execution error: " + ex.Message });
        }
    }

    // ── Submit code against all test cases (student clicks "Submit Code") ──
    [HttpPost("submit/{codingQuestionId}")]
    public async Task<IActionResult> Submit(int codingQuestionId, [FromBody] SubmitCodeRequest req)
    {
        var cq = await db.CodingQuestions
            .Include(c => c.TestCases.OrderBy(t => t.DisplayOrder))
            .FirstOrDefaultAsync(c => c.Id == codingQuestionId);
        if (cq is null) return NotFound(new { message = "Coding question not found" });

        var results = new List<object>();
        int passed = 0;

        foreach (var tc in cq.TestCases)
        {
            var r = await ExecuteCode(req.Code, req.Language, tc.Input);
            var actual = (r.Stdout ?? "").Trim();
            var expected = tc.ExpectedOutput.Trim();
            var isCorrect = actual == expected;
            if (isCorrect) passed++;

            results.Add(new
            {
                testCaseId = tc.Id,
                input = tc.IsHidden ? "[hidden]" : tc.Input,
                expectedOutput = tc.IsHidden ? "[hidden]" : expected,
                actualOutput = tc.IsHidden && !isCorrect ? "[wrong answer]" : actual,
                passed = isCorrect,
                isHidden = tc.IsHidden,
                stderr = r.Stderr,
                compileOutput = r.CompileOutput,
                status = r.Status,
                timeMs = r.TimeMs,
            });
        }

        int total = cq.TestCases.Count;
        return Ok(new
        {
            totalTestCases = total,
            passed,
            allPassed = passed == total,
            score = total > 0 ? (int)Math.Round(passed * 100.0 / total) : 0,
            results,
        });
    }

    // ─── Core execution engine ───────────────────────────────────────
    async Task<ExecutionResult> ExecuteCode(string code, string language, string stdin)
    {
        var lang = language.ToLower().Trim();
        var tmpDir = Path.Combine(Path.GetTempPath(), "lms_judge_" + Guid.NewGuid().ToString("N"));
        Directory.CreateDirectory(tmpDir);

        try
        {
            return lang switch
            {
                "python" or "python3" or "py" => await RunPython(code, stdin, tmpDir),
                "cpp" or "c++" => await RunCpp(code, stdin, tmpDir),
                "c" => await RunC(code, stdin, tmpDir),
                "java" => await RunJava(code, stdin, tmpDir),
                "js" or "javascript" or "node" => await RunJs(code, stdin, tmpDir),
                _ => new ExecutionResult { Status = "UnsupportedLanguage", Stderr = $"Language '{language}' is not supported. Supported: python, cpp, c, java, js" }
            };
        }
        finally
        {
            // Always clean up temp files — even on exception
            try { Directory.Delete(tmpDir, recursive: true); } catch { }
        }
    }

    // ── Python ─────────────────────────────────────────────────────
    async Task<ExecutionResult> RunPython(string code, string stdin, string dir)
    {
        var file = Path.Combine(dir, "solution.py");
        await System.IO.File.WriteAllTextAsync(file, code);
        return await RunProcess("python3", $"\"{file}\"", stdin, dir);
    }

    // ── C++ ────────────────────────────────────────────────────────
    async Task<ExecutionResult> RunCpp(string code, string stdin, string dir)
    {
        var src = Path.Combine(dir, "solution.cpp");
        var exe = Path.Combine(dir, "solution");
        await System.IO.File.WriteAllTextAsync(src, code);

        // Compile first
        var compile = await RunProcess("g++", $"-O2 -o \"{exe}\" \"{src}\" -std=c++17", "", dir, isCompile: true);
        if (!string.IsNullOrEmpty(compile.CompileOutput))
            return compile; // compilation failed

        // Run the compiled binary
        return await RunProcess(exe, "", stdin, dir);
    }

    // ── C ──────────────────────────────────────────────────────────
    async Task<ExecutionResult> RunC(string code, string stdin, string dir)
    {
        var src = Path.Combine(dir, "solution.c");
        var exe = Path.Combine(dir, "solution");
        await System.IO.File.WriteAllTextAsync(src, code);

        var compile = await RunProcess("gcc", $"-O2 -o \"{exe}\" \"{src}\"", "", dir, isCompile: true);
        if (!string.IsNullOrEmpty(compile.CompileOutput))
            return compile;

        return await RunProcess(exe, "", stdin, dir);
    }

    // ── Java ───────────────────────────────────────────────────────
    async Task<ExecutionResult> RunJava(string code, string stdin, string dir)
    {
        // Extract public class name from code; default to "Solution"
        var className = ExtractJavaClassName(code) ?? "Solution";
        var src = Path.Combine(dir, $"{className}.java");
        await System.IO.File.WriteAllTextAsync(src, code);

        var compile = await RunProcess("javac", $"\"{src}\"", "", dir, isCompile: true);
        if (!string.IsNullOrEmpty(compile.CompileOutput))
            return compile;

        // Run from the temp dir so the .class files are found
        return await RunProcess("java", $"-cp \"{dir}\" {className}", stdin, dir);
    }

    // ── JavaScript (Node.js) ───────────────────────────────────────
    async Task<ExecutionResult> RunJs(string code, string stdin, string dir)
    {
        var file = Path.Combine(dir, "solution.js");
        // Inject stdin helper so student code can read input the same way as other languages
        var preamble = @"
const _lines = [];
const _readline = require('readline').createInterface({ input: process.stdin });
_readline.on('line', l => _lines.push(l));
_readline.on('close', () => {
  let _lineIdx = 0;
  function readline() { return _lines[_lineIdx++] ?? ''; }
  function print(v) { process.stdout.write(String(v) + '\n'); }
";
        var epilogue = "\n});\n";
        await System.IO.File.WriteAllTextAsync(file, preamble + code + epilogue);
        return await RunProcess("node", $"\"{file}\"", stdin, dir);
    }

    // ── Process runner ─────────────────────────────────────────────
    async Task<ExecutionResult> RunProcess(string exe, string args, string stdin, string workDir, bool isCompile = false)
    {
        var psi = new ProcessStartInfo
        {
            FileName = exe,
            Arguments = args,
            WorkingDirectory = workDir,
            RedirectStandardInput = true,
            RedirectStandardOutput = true,
            RedirectStandardError = true,
            UseShellExecute = false,
            CreateNoWindow = true,
        };

        var sw = Stopwatch.StartNew();
        using var proc = new Process { StartInfo = psi };

        var stdoutSb = new StringBuilder();
        var stderrSb = new StringBuilder();

        proc.OutputDataReceived += (_, e) => {
            if (e.Data != null && stdoutSb.Length < MaxOutputBytes)
                stdoutSb.AppendLine(e.Data);
        };
        proc.ErrorDataReceived += (_, e) => {
            if (e.Data != null && stderrSb.Length < MaxOutputBytes)
                stderrSb.AppendLine(e.Data);
        };

        try { proc.Start(); }
        catch (Exception ex)
        {
            return new ExecutionResult
            {
                Status = "RuntimeError",
                CompileOutput = isCompile ? $"Cannot start compiler '{exe}': {ex.Message}. Is it installed on the server?" : null,
                Stderr = isCompile ? null : $"Cannot start '{exe}': {ex.Message}",
            };
        }

        proc.BeginOutputReadLine();
        proc.BeginErrorReadLine();

        // Write stdin
        if (!string.IsNullOrEmpty(stdin))
        {
            await proc.StandardInput.WriteAsync(stdin);
            proc.StandardInput.Close();
        }
        else
        {
            proc.StandardInput.Close();
        }

        // Wait with hard timeout
        var finished = await Task.Run(() => proc.WaitForExit(TimeoutMs));
        sw.Stop();

        if (!finished)
        {
            try { proc.Kill(entireProcessTree: true); } catch { }
            return new ExecutionResult
            {
                Status = "TimeLimitExceeded",
                Stderr = $"Execution exceeded the {TimeoutMs / 1000}s time limit.",
                TimeMs = sw.ElapsedMilliseconds,
            };
        }

        var stdout = stdoutSb.ToString().TrimEnd();
        var stderr = stderrSb.ToString().TrimEnd();

        if (isCompile && proc.ExitCode != 0)
            return new ExecutionResult { Status = "CompilationError", CompileOutput = stderr };

        return new ExecutionResult
        {
            Status = proc.ExitCode == 0 ? "Accepted" : "RuntimeError",
            Stdout = string.IsNullOrEmpty(stdout) ? null : stdout,
            Stderr = string.IsNullOrEmpty(stderr) ? null : stderr,
            TimeMs = sw.ElapsedMilliseconds,
        };
    }

    // Extract "public class Foo" → "Foo" from Java source
    static string? ExtractJavaClassName(string code)
    {
        var match = System.Text.RegularExpressions.Regex.Match(code, @"public\s+class\s+(\w+)");
        return match.Success ? match.Groups[1].Value : null;
    }

    record ExecutionResult
    {
        public string Status { get; init; } = "Unknown";
        public string? Stdout { get; init; }
        public string? Stderr { get; init; }
        public string? CompileOutput { get; init; }
        public long TimeMs { get; init; }
    }
}

// ─── Coding Question CRUD ──────────────────────────────────────────────────
[ApiController, Route("api/coding-questions"), Authorize]
public class CodingQuestionsController(LmsDbContext db) : ControllerBase
{
    [HttpPost]
    [Authorize(Roles = "SuperAdmin,OrgAdmin,Instructor")]
    public async Task<IActionResult> Create([FromBody] CreateCodingQuestionRequest req)
    {
        var q = await db.MockTestQuestions.FindAsync(req.MockTestQuestionId);
        if (q is null) return NotFound(new { message = "MockTestQuestion not found" });

        var cq = new CodingQuestion
        {
            MockTestQuestionId = req.MockTestQuestionId,
            ProblemStatement = req.ProblemStatement,
            Constraints = req.Constraints,
            SampleInput = req.SampleInput,
            SampleOutput = req.SampleOutput,
            StarterCodeCpp = req.StarterCodeCpp,
            StarterCodeJava = req.StarterCodeJava,
            StarterCodePython = req.StarterCodePython,
            StarterCodeJs = req.StarterCodeJs,
        };
        if (req.TestCases != null)
            foreach (var tc in req.TestCases)
                cq.TestCases.Add(new TestCase
                {
                    Input = tc.Input,
                    ExpectedOutput = tc.ExpectedOutput,
                    IsHidden = tc.IsHidden,
                    DisplayOrder = tc.Order,
                });

        db.CodingQuestions.Add(cq);
        await db.SaveChangesAsync();
        return Ok(new { cq.Id });
    }

    [HttpGet("{id}")]
    public async Task<IActionResult> Get(int id)
    {
        var cq = await db.CodingQuestions
            .Include(c => c.TestCases.OrderBy(t => t.DisplayOrder))
            .FirstOrDefaultAsync(c => c.Id == id);
        if (cq is null) return NotFound();
        return Ok(cq);
    }

    [HttpPut("{id}/test-cases")]
    [Authorize(Roles = "SuperAdmin,OrgAdmin,Instructor")]
    public async Task<IActionResult> UpdateTestCases(int id, [FromBody] List<TestCaseRequest> req)
    {
        var cq = await db.CodingQuestions
            .Include(c => c.TestCases)
            .FirstOrDefaultAsync(c => c.Id == id);
        if (cq is null) return NotFound();

        db.TestCases.RemoveRange(cq.TestCases);
        foreach (var tc in req)
            cq.TestCases.Add(new TestCase
            {
                Input = tc.Input,
                ExpectedOutput = tc.ExpectedOutput,
                IsHidden = tc.IsHidden,
                DisplayOrder = tc.Order
            });

        await db.SaveChangesAsync();
        return NoContent();
    }
}