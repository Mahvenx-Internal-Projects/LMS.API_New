using LMS.API.Data;
using LMS.API.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MySqlConnector;

namespace LMS.API.Controllers;

[ApiController, Route("api/seed")]
[Authorize(Roles = "SuperAdmin")]
public class SeedController(IConfiguration config, IWebHostEnvironment env, ILogger<SeedController> logger) : ControllerBase
{
    // ── Upload SQL file ────────────────────────────────────────────
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

    // ── Run SQL file ───────────────────────────────────────────────
    [HttpPost("run")]
    public async Task<IActionResult> Run()
    {
        var wwwroot = env.WebRootPath ?? Path.Combine(Directory.GetCurrentDirectory(), "wwwroot");
        var sqlPath = Path.Combine(wwwroot, "seed_assessments_final.sql");

        if (!System.IO.File.Exists(sqlPath))
            return NotFound(new
            {
                message = "Seed file not found. Upload it first via POST /api/seed/upload",
                expectedPath = sqlPath
            });

        var connStr = config.GetConnectionString("DefaultConnection")!;
        var stats = new SeedStats();

        try
        {
            var sql = await System.IO.File.ReadAllTextAsync(sqlPath);
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
                    await cmd.ExecuteNonQueryAsync();

                    if (trimmed.StartsWith("INSERT INTO MockTests", StringComparison.OrdinalIgnoreCase)) stats.MockTests++;
                    else if (trimmed.StartsWith("INSERT INTO MockTestQuestions", StringComparison.OrdinalIgnoreCase)) stats.Questions++;
                    else if (trimmed.StartsWith("INSERT INTO MockTestOptions", StringComparison.OrdinalIgnoreCase)) stats.Options++;
                    else if (trimmed.StartsWith("INSERT INTO CodingQuestions", StringComparison.OrdinalIgnoreCase)) stats.CodingQuestions++;
                    else if (trimmed.StartsWith("INSERT INTO TestCases", StringComparison.OrdinalIgnoreCase)) stats.TestCases++;
                }
                catch (MySqlException ex) when (ex.Number == 1062) { stats.Skipped++; }
                catch (Exception ex)
                {
                    logger.LogWarning("Seed statement failed: {Error} | SQL: {Stmt}",
                        ex.Message, trimmed.Length > 200 ? trimmed[..200] + "…" : trimmed);
                    stats.Errors++;
                }
            }

            return Ok(new
            {
                message = "Seed completed!",
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

    // ── Status ─────────────────────────────────────────────────────
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

    // ── Seed ServiceNow ITSM Questions directly via EF Core ────────
    // POST /api/seed/servicenow?examId=4
    // No file upload needed — inserts 18 MCQ + 2 coding questions in one call
    [HttpPost("servicenow")]
    public async Task<IActionResult> SeedServiceNow([FromQuery] int? examId, [FromServices] LmsDbContext db)
    {
        // Find exam
        var exam = examId.HasValue
            ? await db.MockTests.FindAsync(examId.Value)
            : await db.MockTests.FirstOrDefaultAsync(m => m.Title.Contains("ServiceNow") || m.Title.Contains("ITSM"));

        if (exam is null)
            return NotFound(new { message = "No ServiceNow/ITSM exam found. Pass ?examId= or create an exam first." });

        logger.LogInformation("Seeding ServiceNow into exam {Id}: {Title}", exam.Id, exam.Title);

        // Clean existing questions
        var existingQIds = await db.MockTestQuestions
            .Where(q => q.MockTestId == exam.Id)
            .Select(q => q.Id).ToListAsync();

        var codingQIds = await db.CodingQuestions
            .Where(c => existingQIds.Contains(c.MockTestQuestionId))
            .Select(c => c.Id).ToListAsync();

        db.TestCases.RemoveRange(db.TestCases.Where(t => codingQIds.Contains(t.CodingQuestionId)));
        db.CodingQuestions.RemoveRange(db.CodingQuestions.Where(c => existingQIds.Contains(c.MockTestQuestionId)));
        db.MockTestOptions.RemoveRange(db.MockTestOptions.Where(o => existingQIds.Contains(o.QuestionId)));
        db.MockTestQuestions.RemoveRange(db.MockTestQuestions.Where(q => q.MockTestId == exam.Id));
        await db.SaveChangesAsync();

        // ── 18 MCQ Questions ──────────────────────────────────────
        var mcqs = new (string text, string topic, int diff, string correct, string[] wrong)[]
        {
            ("What is the primary purpose of Incident Management in ITIL?", "Incident Management", 1,
                "To restore normal service operation as quickly as possible",
                ["To identify root cause of recurring incidents", "To plan and implement changes to IT infrastructure", "To manage the IT asset lifecycle"]),

            ("In ServiceNow, which table stores all Incident records?", "ServiceNow Platform", 1,
                "incident",
                ["task", "sc_request", "change_request"]),

            ("An incident has Impact = 2 (Medium) and Urgency = 1 (High). What is the Priority?", "Incident Management", 2,
                "2 - High",
                ["1 - Critical", "3 - Medium", "4 - Low"]),

            ("Which Change type requires full CAB approval for significant changes?", "Change Management", 1,
                "Normal Change",
                ["Standard Change", "Emergency Change", "Minor Change"]),

            ("What does CMDB stand for?", "CMDB", 1,
                "Configuration Management Database",
                ["Change Management Decision Board", "Centralized Monitoring and Diagnostics Base", "Configuration Monitoring and Deployment Board"]),

            ("What is an SLA in the context of ITSM?", "SLA Management", 1,
                "A formal agreement defining the expected level of service between provider and customer",
                ["A software tool used to log incidents", "A checklist for deployment activities", "A report generated after a major incident"]),

            ("In ServiceNow, what is GlideRecord used for?", "ServiceNow Platform", 2,
                "Querying and manipulating database records using server-side JavaScript",
                ["Designing UI forms in Service Portal", "Creating workflow diagrams", "Managing SLA timers"]),

            ("Which ITIL process identifies root causes of recurring incidents?", "Problem Management", 1,
                "Problem Management",
                ["Incident Management", "Change Management", "Event Management"]),

            ("What is a Configuration Item (CI) in CMDB?", "CMDB", 1,
                "Any component that needs to be managed to deliver an IT service",
                ["A user who configures ServiceNow workflows", "A type of change request", "A document that defines IT policies"]),

            ("What is the correct Change Management lifecycle sequence in ServiceNow?", "Change Management", 2,
                "Draft → Assess → Authorize → Scheduled → Implement → Review → Closed",
                ["New → In Progress → Resolved → Closed", "Requested → Approved → Deployed → Done", "Open → Pending → Active → Resolved"]),

            ("What is the purpose of the Service Catalog in ServiceNow?", "Service Catalog", 1,
                "To allow users to request IT services through a self-service portal",
                ["To list all incidents raised in the system", "To track software licenses", "To manage employee onboarding only"]),

            ("Which ServiceNow scripting type runs on the server side?", "ServiceNow Platform", 2,
                "Business Rules and Script Includes",
                ["Client Scripts and UI Policies", "UI Actions only", "Jelly Scripts"]),

            ("What does OLA stand for in ITSM?", "SLA Management", 2,
                "Operational Level Agreement",
                ["Organizational License Agreement", "Online Logging Application", "Outage Level Alert"]),

            ("In ITIL, what is a Workaround?", "Problem Management", 1,
                "A temporary solution that reduces incident impact without resolving the root cause",
                ["A permanent fix after root cause analysis", "A script that auto-closes incidents", "A change request raised after an incident"]),

            ("Which ServiceNow feature automatically routes incidents to the correct team?", "Incident Management", 2,
                "Assignment Rules",
                ["Approval Policies", "Escalation Policies", "Notification Rules"]),

            ("What is a Major Incident in ITSM?", "Incident Management", 1,
                "An incident with highest impact requiring coordinated response and dedicated team",
                ["Any incident taking more than 1 hour to resolve", "An incident raised by a manager", "An incident affecting only one user"]),

            ("In ServiceNow, what is a Business Rule?", "ServiceNow Platform", 2,
                "A server-side script that runs when a record is displayed, inserted, updated, or deleted",
                ["A rule that enforces password policies", "A client-side script that validates form fields", "A workflow that sends emails to approvers"]),

            ("Which ITIL concept describes total available time divided by total agreed service time?", "SLA Management", 2,
                "Availability (expressed as a percentage)",
                ["Mean Time to Repair (MTTR)", "Mean Time Between Failures (MTBF)", "Recovery Point Objective (RPO)"]),
        };

        int order = 1;
        foreach (var (text, topic, diff, correct, wrong) in mcqs)
        {
            var q = new MockTestQuestion
            {
                MockTestId = exam.Id,
                Text = text,
                Topic = topic,
                Difficulty = (MockTestDifficulty)diff,
                QuestionType = MockQuestionType.SingleChoice,
                Marks = 1,
                NegativeMarks = 0,
                DisplayOrder = order++
            };
            db.MockTestQuestions.Add(q);
            await db.SaveChangesAsync();

            var allOptions = new[] { correct }.Concat(wrong).ToArray();
            for (int i = 0; i < allOptions.Length; i++)
                db.MockTestOptions.Add(new MockTestOption
                {
                    QuestionId = q.Id,
                    Text = allOptions[i],
                    IsCorrect = i == 0,
                    DisplayOrder = i + 1
                });
            await db.SaveChangesAsync();
        }

        // ── Q19: Incident Priority Calculator (Coding) ─────────────
        var cq1 = new MockTestQuestion
        {
            MockTestId = exam.Id,
            Text = "Incident Priority Calculator",
            Topic = "Incident Management",
            Difficulty = MockTestDifficulty.Medium,
            QuestionType = MockQuestionType.Coding,
            Marks = 10,
            NegativeMarks = 0,
            DisplayOrder = 19
        };
        db.MockTestQuestions.Add(cq1);
        await db.SaveChangesAsync();

        var coding1 = new CodingQuestion
        {
            MockTestQuestionId = cq1.Id,
            ProblemStatement = "<p>In ServiceNow ITSM, incident <strong>Priority</strong> is calculated from <strong>Impact</strong> and <strong>Urgency</strong>.</p><br><p><strong>Priority Matrix:</strong></p><table border='1' cellpadding='6' style='border-collapse:collapse'><tr style='background:#1e293b;color:white'><th>Impact / Urgency</th><th>1-High</th><th>2-Medium</th><th>3-Low</th></tr><tr><td><b>1-High</b></td><td>1-Critical</td><td>2-High</td><td>3-Medium</td></tr><tr><td><b>2-Medium</b></td><td>2-High</td><td>3-Medium</td><td>4-Low</td></tr><tr><td><b>3-Low</b></td><td>3-Medium</td><td>4-Low</td><td>5-Planning</td></tr></table><br><p>Given <strong>impact</strong> and <strong>urgency</strong> (each 1-3), print the priority label.</p><p><strong>Input:</strong> Two integers on one line — impact urgency</p>",
            Constraints = "1 <= impact <= 3\n1 <= urgency <= 3",
            SampleInput = "1 2",
            SampleOutput = "2-High",
            StarterCodeJs = "const lines = [];\nrequire('readline').createInterface({ input: process.stdin })\n  .on('line', l => lines.push(l.trim()))\n  .on('close', () => {\n    const [impact, urgency] = lines[0].split(' ').map(Number);\n    const matrix = {\n      '1-1': '1-Critical', '1-2': '2-High',   '1-3': '3-Medium',\n      '2-1': '2-High',    '2-2': '3-Medium', '2-3': '4-Low',\n      '3-1': '3-Medium',  '3-2': '4-Low',    '3-3': '5-Planning'\n    };\n    // TODO: print the priority label\n    const key = `${impact}-${urgency}`;\n    \n  });"
        };
        db.CodingQuestions.Add(coding1);
        await db.SaveChangesAsync();

        (string input, string output, bool hidden)[] tc1 =
        [
            ("1 2", "2-High", false), ("1 1", "1-Critical", false),
            ("3 3", "5-Planning", true), ("2 1", "2-High", true), ("1 3", "3-Medium", true)
        ];
        for (int i = 0; i < tc1.Length; i++)
            db.TestCases.Add(new TestCase { CodingQuestionId = coding1.Id, Input = tc1[i].input, ExpectedOutput = tc1[i].output, IsHidden = tc1[i].hidden, DisplayOrder = i });
        await db.SaveChangesAsync();

        // ── Q20: SLA Breach Checker (Coding) ───────────────────────
        var cq2 = new MockTestQuestion
        {
            MockTestId = exam.Id,
            Text = "SLA Breach Checker",
            Topic = "SLA Management",
            Difficulty = MockTestDifficulty.Medium,
            QuestionType = MockQuestionType.Coding,
            Marks = 10,
            NegativeMarks = 0,
            DisplayOrder = 20
        };
        db.MockTestQuestions.Add(cq2);
        await db.SaveChangesAsync();

        var coding2 = new CodingQuestion
        {
            MockTestQuestionId = cq2.Id,
            ProblemStatement = "<p>Check whether an incident's SLA has been <strong>BREACHED</strong> or <strong>MET</strong> based on its priority.</p><br><p><strong>SLA Resolution Targets:</strong></p><table border='1' cellpadding='6' style='border-collapse:collapse'><tr style='background:#1e293b;color:white'><th>Priority</th><th>Target Hours</th></tr><tr><td>1 - Critical</td><td>4 hours</td></tr><tr><td>2 - High</td><td>8 hours</td></tr><tr><td>3 - Medium</td><td>24 hours</td></tr><tr><td>4 - Low</td><td>72 hours</td></tr><tr><td>5 - Planning</td><td>168 hours</td></tr></table><br><p>Given priority (1-5) and hours taken, print <strong>MET</strong> or <strong>BREACHED</strong>.</p><p><strong>Input:</strong> Line 1: priority, Line 2: hours taken</p>",
            Constraints = "1 <= priority <= 5\n0 <= hours <= 10000",
            SampleInput = "2\n10",
            SampleOutput = "BREACHED",
            StarterCodeJs = "const lines = [];\nrequire('readline').createInterface({ input: process.stdin })\n  .on('line', l => lines.push(l.trim()))\n  .on('close', () => {\n    const priority = parseInt(lines[0]);\n    const hours    = parseInt(lines[1]);\n    const slaTargets = { 1: 4, 2: 8, 3: 24, 4: 72, 5: 168 };\n    // TODO: print MET or BREACHED\n    \n  });"
        };
        db.CodingQuestions.Add(coding2);
        await db.SaveChangesAsync();

        (string input, string output, bool hidden)[] tc2 =
        [
            ("2\n10", "BREACHED", false), ("3\n20", "MET", false),
            ("1\n4", "MET", true), ("4\n73", "BREACHED", true), ("5\n100", "MET", true)
        ];
        for (int i = 0; i < tc2.Length; i++)
            db.TestCases.Add(new TestCase { CodingQuestionId = coding2.Id, Input = tc2[i].input, ExpectedOutput = tc2[i].output, IsHidden = tc2[i].hidden, DisplayOrder = i });
        await db.SaveChangesAsync();

        // Fix exam settings
        exam.TotalQuestions = 20;
        exam.RandomizeQuestions = false;
        exam.TimeLimitMins = 30;
        exam.MaxAttempts = 1;
        await db.SaveChangesAsync();

        return Ok(new
        {
            message = "ServiceNow seed complete!",
            examId = exam.Id,
            examTitle = exam.Title,
            mcqInserted = 18,
            codingInserted = 2,
            totalQuestions = 20
        });
    }

    // ── Helpers ────────────────────────────────────────────────────
    static List<string> SplitStatements(string sql)
    {
        var statements = new List<string>();
        var current = new System.Text.StringBuilder();
        bool inString = false;
        char strChar = '\'';

        for (int i = 0; i < sql.Length; i++)
        {
            char c = sql[i];
            if (!inString && (c == '\'' || c == '"')) { inString = true; strChar = c; current.Append(c); }
            else if (inString && c == strChar)
            {
                if (i + 1 < sql.Length && sql[i + 1] == strChar) { current.Append(c); current.Append(sql[++i]); }
                else { inString = false; current.Append(c); }
            }
            else if (!inString && c == ';') { var s = current.ToString().Trim(); if (!string.IsNullOrEmpty(s)) statements.Add(s); current.Clear(); }
            else current.Append(c);
        }
        var last = current.ToString().Trim();
        if (!string.IsNullOrEmpty(last)) statements.Add(last);
        return statements;
    }

    class SeedStats
    {
        public int MockTests, Questions, Options, CodingQuestions, TestCases, Skipped, Errors;
     
    }
}