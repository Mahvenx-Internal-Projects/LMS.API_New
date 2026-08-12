using LMS.API.Data;
using LMS.API.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Text.Json;

namespace LMS.API.Controllers;

[ApiController, Route("api/lesson-exam")]
[Authorize]
public class LessonExamController(LmsDbContext db) : ControllerBase
{
    private int UserId => int.Parse(User.FindFirst("sub")?.Value ?? "0");

    // ── GET exam for a lesson ─────────────────────────────────────
    [HttpGet("lesson/{lessonId}")]
    public async Task<IActionResult> GetByLesson(int lessonId)
    {
        var exam = await db.LessonExams
            .Include(e => e.Questions.OrderBy(q => q.DisplayOrder))
            .FirstOrDefaultAsync(e => e.LessonId == lessonId);
        if (exam is null) return Ok(null);
        return Ok(MapExam(exam));
    }

    // ── GET exams for multiple lessons (for dropdown) ─────────────
    [HttpGet("by-course/{courseId}")]
    public async Task<IActionResult> GetByCourse(int courseId)
    {
        var moduleIds = await db.Modules.Where(m => m.CourseId == courseId).Select(m => m.Id).ToListAsync();
        var lessonIds = await db.Lessons.Where(l => moduleIds.Contains(l.ModuleId)).Select(l => l.Id).ToListAsync();
        var exams = await db.LessonExams
            .Include(e => e.Questions.OrderBy(q => q.DisplayOrder))
            .Where(e => lessonIds.Contains(e.LessonId) && e.IsActive)
            .ToListAsync();

        // Get lesson titles
        var lessons = await db.Lessons
            .Where(l => lessonIds.Contains(l.Id))
            .Select(l => new { l.Id, l.Title })
            .ToListAsync();

        return Ok(exams.Select(e => new {
            exam = MapExam(e),
            lessonTitle = lessons.FirstOrDefault(l => l.Id == e.LessonId)?.Title ?? "Unknown Lesson"
        }));
    }

    // ── UPSERT exam ───────────────────────────────────────────────
    [HttpPost("lesson/{lessonId}"), Authorize(Roles = "SuperAdmin,OrgAdmin,Instructor")]
    public async Task<IActionResult> Upsert(int lessonId, [FromBody] LessonExamRequest req)
    {
        var exam = await db.LessonExams
            .Include(e => e.Questions)
            .FirstOrDefaultAsync(e => e.LessonId == lessonId);

        if (exam is null) {
            exam = new LessonExam { LessonId = lessonId };
            db.LessonExams.Add(exam);
        }

        exam.Title       = req.Title ?? "Lesson Quiz";
        exam.Description = req.Description;
        exam.PassPercent = req.PassPercent;
        exam.MaxAttempts = req.MaxAttempts;
        exam.IsRequired  = req.IsRequired;
        exam.IsActive    = req.IsActive;

        db.LessonExamQuestions.RemoveRange(exam.Questions);
        await db.SaveChangesAsync();

        for (int i = 0; i < req.Questions.Count; i++) {
            var q = req.Questions[i];
            Enum.TryParse<LessonQuestionType>(q.QuestionType, out var qt);
            db.LessonExamQuestions.Add(new LessonExamQuestion {
                LessonExamId  = exam.Id,
                QuestionText  = q.QuestionText,
                QuestionType  = qt,
                OptionA       = q.OptionA,
                OptionB       = q.OptionB,
                OptionC       = q.OptionC,
                OptionD       = q.OptionD,
                CorrectOption = q.CorrectOption,
                Explanation   = q.Explanation,
                DisplayOrder  = i,
            });
        }

        var lesson = await db.Lessons.FindAsync(lessonId);
        if (lesson is not null) {
            lesson.RequireExamToProgress = req.IsRequired && req.IsActive;
        }
        await db.SaveChangesAsync();
        return Ok(new { message = "Exam saved successfully!", examId = exam.Id, questionCount = req.Questions.Count });
    }

    // ── DELETE exam ───────────────────────────────────────────────
    [HttpDelete("{examId}"), Authorize(Roles = "SuperAdmin,OrgAdmin,Instructor")]
    public async Task<IActionResult> Delete(int examId)
    {
        var exam = await db.LessonExams.FindAsync(examId);
        if (exam is null) return NotFound();
        var lesson = await db.Lessons.FindAsync(exam.LessonId);
        if (lesson is not null) lesson.RequireExamToProgress = false;
        db.LessonExams.Remove(exam);
        await db.SaveChangesAsync();
        return Ok(new { message = "Exam deleted" });
    }

    // ── SUBMIT attempt ────────────────────────────────────────────
    [HttpPost("{examId}/attempt")]
    public async Task<IActionResult> Submit(int examId, [FromBody] ExamAttemptRequest req)
    {
        var userId = UserId;
        var exam = await db.LessonExams
            .Include(e => e.Questions)
            .Include(e => e.Attempts.Where(a => a.UserId == userId))
            .FirstOrDefaultAsync(e => e.Id == examId);

        if (exam is null) return NotFound();
        if (exam.MaxAttempts > 0 && exam.Attempts.Count >= exam.MaxAttempts)
            return BadRequest(new { message = $"Maximum {exam.MaxAttempts} attempts reached" });

        int correct = 0, total = exam.Questions.Count;
        var results = new List<object>();

        foreach (var q in exam.Questions) {
            var userAns = req.Answers.GetValueOrDefault(q.Id.ToString(), "");
            bool isCorrect = false;

            switch (q.QuestionType) {
                case LessonQuestionType.MultiChoice:
                    // both must have same set of answers
                    var correctSet = (q.CorrectOption ?? "").Split(',').Select(x => x.Trim()).OrderBy(x => x).ToList();
                    var userSet    = userAns.Split(',').Select(x => x.Trim()).OrderBy(x => x).ToList();
                    isCorrect = correctSet.SequenceEqual(userSet);
                    break;
                case LessonQuestionType.ShortAnswer:
                case LessonQuestionType.TextArea:
                    isCorrect = true; // manual grading — auto pass
                    break;
                default:
                    isCorrect = !string.IsNullOrEmpty(userAns) &&
                        userAns.Equals(q.CorrectOption, StringComparison.OrdinalIgnoreCase);
                    break;
            }

            if (isCorrect) correct++;
            results.Add(new {
                questionId = q.Id, userAnswer = userAns,
                correctAnswer = q.CorrectOption, isCorrect,
                explanation = q.Explanation
            });
        }

        int score  = total > 0 ? (int)Math.Round(correct * 100.0 / total) : 100;
        bool passed = score >= exam.PassPercent;

        var attempt = new LessonExamAttempt {
            LessonExamId = examId, UserId = userId,
            Score = score, Passed = passed,
            AnswersJson = JsonSerializer.Serialize(req.Answers),
            AttemptedAt = DateTime.UtcNow,
        };
        db.LessonExamAttempts.Add(attempt);

        if (passed) {
            var progress = await db.LessonProgresses
                .FirstOrDefaultAsync(p => p.UserId == userId && p.LessonId == exam.LessonId);
            if (progress is not null) { progress.IsCompleted = true; progress.UpdatedAt = DateTime.UtcNow; }
            else db.LessonProgresses.Add(new LessonProgress {
                UserId = userId, LessonId = exam.LessonId,
                IsCompleted = true, UpdatedAt = DateTime.UtcNow });
        }
        await db.SaveChangesAsync();

        return Ok(new {
            score, passed, correct, total,
            passPercent  = exam.PassPercent,
            attemptsUsed = exam.Attempts.Count + 1,
            attemptsLeft = exam.MaxAttempts == 0 ? 999 : exam.MaxAttempts - (exam.Attempts.Count + 1),
            message      = passed ? $"🎉 Congratulations! You scored {score}%. You can proceed to the next lesson." : $"You scored {score}%. You need {exam.PassPercent}% to pass.",
            results,
            correctAnswers = passed ? exam.Questions.ToDictionary(q => q.Id.ToString(), q => q.CorrectOption) : null
        });
    }

    // ── My best attempt ───────────────────────────────────────────
    [HttpGet("{examId}/my-attempt")]
    public async Task<IActionResult> MyAttempt(int examId)
    {
        var userId = UserId;
        var best = await db.LessonExamAttempts
            .Where(a => a.LessonExamId == examId && a.UserId == userId)
            .OrderByDescending(a => a.Score).FirstOrDefaultAsync();
        return Ok(best is null ? null : new { best.Score, best.Passed, best.AttemptedAt, attempts = db.LessonExamAttempts.Count(a => a.LessonExamId == examId && a.UserId == userId) });
    }

    // ── Can proceed to next lesson? ───────────────────────────────
    [HttpGet("can-proceed/{lessonId}")]
    public async Task<IActionResult> CanProceed(int lessonId)
    {
        var userId = UserId;
        var lesson = await db.Lessons.FindAsync(lessonId);
        if (lesson is null) return NotFound();
        if (!lesson.RequireExamToProgress) return Ok(new { canProceed = true });

        var exam = await db.LessonExams.FirstOrDefaultAsync(e => e.LessonId == lessonId && e.IsActive);
        if (exam is null) return Ok(new { canProceed = true });

        var passed = await db.LessonExamAttempts.AnyAsync(a => a.LessonExamId == exam.Id && a.UserId == userId && a.Passed);
        return Ok(new { canProceed = passed, examId = exam.Id });
    }

    // ── Helper ────────────────────────────────────────────────────
    static object MapExam(LessonExam e) => new {
        e.Id, e.LessonId, e.Title, e.Description,
        e.PassPercent, e.MaxAttempts, e.IsRequired, e.IsActive,
        questions = e.Questions.Select(q => new {
            q.Id, q.QuestionText,
            questionType = q.QuestionType.ToString(),
            q.OptionA, q.OptionB, q.OptionC, q.OptionD,
            q.CorrectOption, q.Explanation, q.DisplayOrder
        })
    };
}

public record LessonExamRequest(
    string? Title, string? Description,
    int PassPercent, int MaxAttempts,
    bool IsRequired, bool IsActive,
    List<QuestionRequest> Questions
);
public record QuestionRequest(
    string QuestionText, string QuestionType,
    string? OptionA, string? OptionB, string? OptionC, string? OptionD,
    string? CorrectOption, string? Explanation
);
public record ExamAttemptRequest(Dictionary<string, string> Answers);
