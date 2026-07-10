using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MySqlConnector;

namespace LMS.API.Controllers;

/// <summary>
/// One-time seed data runner — SuperAdmin only.
/// POST /api/seed/run  — executes the bundled SQL file against the database.
/// The SQL file is expected at wwwroot/seed_assessments_final.sql on the server,
/// OR you can upload it via POST /api/seed/upload first, then run it.
/// </summary>
[ApiController, Route("api/seed")]
[Authorize(Roles = "SuperAdmin")]
public class SeedController(IConfiguration config, IWebHostEnvironment env, ILogger<SeedController> logger) : ControllerBase
{
    // ── Upload the SQL file to wwwroot ─────────────────────────────
    [HttpPost("upload")]
    public async Task<IActionResult> Upload(IFormFile file)
    {
        if (file is null || !file.FileName.EndsWith(".sql", StringComparison.OrdinalIgnoreCase))
            return BadRequest(new { message = "Please upload a .sql file" });

        var wwwroot = env.WebRootPath ?? Path.Combine(Directory.GetCurrentDirectory(), "wwwroot");
        Directory.CreateDirectory(wwwroot);
        var dest = Path.Combine(wwwroot, "seed_assessments_final.sql");

        using var fs = System.IO.File.Create(dest);
        await file.CopyToAsync(fs);

        var sizeKb = Math.Round(file.Length / 1024.0, 1);
        logger.LogInformation("Seed SQL uploaded: {Path} ({Size} KB)", dest, sizeKb);
        return Ok(new { message = $"File uploaded ({sizeKb} KB). Ready to run.", path = dest });
    }

    // ── Run the SQL file ───────────────────────────────────────────
    [HttpPost("run")]
    public async Task<IActionResult> Run()
    {
        var wwwroot = env.WebRootPath ?? Path.Combine(Directory.GetCurrentDirectory(), "wwwroot");
        var sqlPath = Path.Combine(wwwroot, "seed_assessments_final.sql");

        if (!System.IO.File.Exists(sqlPath))
            return NotFound(new
            {
                message = "Seed file not found on server. Upload it first via POST /api/seed/upload",
                expectedPath = sqlPath
            });

        var connStr = config.GetConnectionString("DefaultConnection")!;
        var stats = new SeedStats();

        try
        {
            var sql = await System.IO.File.ReadAllTextAsync(sqlPath);

            // Split on semicolons but keep SET statements atomic.
            // We skip blank lines and pure comments.
            var statements = SplitStatements(sql);

            await using var conn = new MySqlConnection(connStr);
            await conn.OpenAsync();

            foreach (var stmt in statements)
            {
                var trimmed = stmt.Trim();
                if (string.IsNullOrWhiteSpace(trimmed) || trimmed.StartsWith("--")) continue;

                try
                {
                    await using var cmd = new MySqlCommand(trimmed, conn);
                    cmd.CommandTimeout = 120;
                    var affected = await cmd.ExecuteNonQueryAsync();

                    if (trimmed.StartsWith("INSERT INTO MockTests", StringComparison.OrdinalIgnoreCase))
                        stats.MockTests++;
                    else if (trimmed.StartsWith("INSERT INTO MockTestQuestions", StringComparison.OrdinalIgnoreCase))
                        stats.Questions++;
                    else if (trimmed.StartsWith("INSERT INTO MockTestOptions", StringComparison.OrdinalIgnoreCase))
                        stats.Options++;
                    else if (trimmed.StartsWith("INSERT INTO CodingQuestions", StringComparison.OrdinalIgnoreCase))
                        stats.CodingQuestions++;
                    else if (trimmed.StartsWith("INSERT INTO TestCases", StringComparison.OrdinalIgnoreCase))
                        stats.TestCases++;
                }
                catch (MySqlException ex) when (ex.Number == 1062) // Duplicate entry
                {
                    stats.Skipped++; // Already seeded — skip silently
                }
                catch (Exception ex)
                {
                    logger.LogWarning("Seed statement failed: {Error} | SQL: {Stmt}",
                        ex.Message, trimmed.Length > 200 ? trimmed[..200] + "…" : trimmed);
                    stats.Errors++;
                }
            }

            logger.LogInformation("Seed completed: {Stats}", stats);
            return Ok(new
            {
                message = "Seed completed successfully!",
                stats = new
                {
                    mockTestsCreated = stats.MockTests,
                    questionsInserted = stats.Questions,
                    optionsInserted = stats.Options,
                    codingQsInserted = stats.CodingQuestions,
                    testCasesInserted = stats.TestCases,
                    duplicatesSkipped = stats.Skipped,
                    statementsWithError = stats.Errors,
                }
            });
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "Seed failed");
            return StatusCode(500, new { message = "Seed failed: " + ex.Message });
        }
    }

    // ── Status check ───────────────────────────────────────────────
    [HttpGet("status")]
    public IActionResult Status()
    {
        var wwwroot = env.WebRootPath ?? Path.Combine(Directory.GetCurrentDirectory(), "wwwroot");
        var sqlPath = Path.Combine(wwwroot, "seed_assessments_final.sql");
        var exists = System.IO.File.Exists(sqlPath);
        return Ok(new
        {
            fileReady = exists,
            path = sqlPath,
            sizeMb = exists ? Math.Round(new FileInfo(sqlPath).Length / 1024.0 / 1024.0, 2) : 0,
            instructions = exists
                ? "File is ready. POST /api/seed/run to execute."
                : "Upload the file first via POST /api/seed/upload with field name 'file'."
        });
    }

    static List<string> SplitStatements(string sql)
    {
        // Split on ';' that are NOT inside string literals.
        // This is a simple splitter — handles normal INSERT/SET statements.
        var statements = new List<string>();
        var current = new System.Text.StringBuilder();
        bool inString = false;
        char strChar = '\'';

        for (int i = 0; i < sql.Length; i++)
        {
            char c = sql[i];

            if (!inString && (c == '\'' || c == '"'))
            {
                inString = true;
                strChar = c;
                current.Append(c);
            }
            else if (inString && c == strChar)
            {
                // Check for escaped quote ('')
                if (i + 1 < sql.Length && sql[i + 1] == strChar)
                {
                    current.Append(c);
                    current.Append(sql[++i]);
                }
                else
                {
                    inString = false;
                    current.Append(c);
                }
            }
            else if (!inString && c == ';')
            {
                var stmt = current.ToString().Trim();
                if (!string.IsNullOrEmpty(stmt))
                    statements.Add(stmt);
                current.Clear();
            }
            else
            {
                current.Append(c);
            }
        }

        var last = current.ToString().Trim();
        if (!string.IsNullOrEmpty(last))
            statements.Add(last);

        return statements;
    }

    class SeedStats
    {
        public int MockTests, Questions, Options, CodingQuestions, TestCases, Skipped, Errors;
        public override string ToString() =>
            $"Tests:{MockTests} Qs:{Questions} Opts:{Options} Code:{CodingQuestions} TCs:{TestCases} Skip:{Skipped} Err:{Errors}";
    }
}