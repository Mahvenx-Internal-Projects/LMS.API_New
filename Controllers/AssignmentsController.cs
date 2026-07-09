using LMS.API.Data;
using LMS.API.DTOs;
using LMS.API.Models;
using LMS.API.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace LMS.API.Controllers;

[ApiController, Route("api/assignments"), Authorize]
public class AssignmentsController(LmsDbContext db, IEmailService email) : ControllerBase
{
    // ─── Trainer: list assignments for a course ────────────────
    [HttpGet("course/{courseId}")]
    public async Task<IActionResult> GetByCourse(int courseId)
    {
        var list = await db.Assignments
            .Include(a => a.CreatedBy)
            .Include(a => a.Course)
            .Include(a => a.Submissions)
            .Where(a => a.CourseId == courseId)
            .OrderByDescending(a => a.CreatedAt)
            .ToListAsync();

        return Ok(list.Select(a => MapAssignment(a, null)));
    }

    // ─── Student: my assignments ───────────────────────────────
    // Returns each assignment with the STUDENT'S OWN submission state
    // (myStatus / myMarks / myFeedback) — separate from the assignment's
    // own publish status (Draft/Published/Closed).
    [HttpGet("student/{studentId}")]
    public async Task<IActionResult> GetForStudent(int studentId)
    {
        var enrolledCourseIds = await db.Enrollments
            .Where(e => e.UserId == studentId && e.Status == EnrollmentStatus.Active)
            .Select(e => e.CourseId).ToListAsync();

        var list = await db.Assignments
            .Include(a => a.CreatedBy)
            .Include(a => a.Course)
            .Include(a => a.Submissions.Where(s => s.StudentId == studentId))
            .Where(a => enrolledCourseIds.Contains(a.CourseId) && a.Status == AssignmentStatus.Published)
            .OrderBy(a => a.DueDate)
            .ToListAsync();

        return Ok(list.Select(a => {
            var sub = a.Submissions.FirstOrDefault();
            return MapAssignment(a, sub);
        }));
    }

    [HttpGet("{id}")]
    public async Task<IActionResult> Get(int id)
    {
        var a = await db.Assignments.Include(a => a.CreatedBy).Include(a => a.Course)
            .Include(a => a.Submissions).ThenInclude(s => s.Student)
            .FirstOrDefaultAsync(a => a.Id == id);
        return a is null ? NotFound() : Ok(MapAssignment(a, null));
    }

    [HttpPost]
    [Authorize(Roles = "SuperAdmin,OrgAdmin,Instructor")]
    public async Task<IActionResult> Create([FromBody] CreateAssignmentRequest req)
    {
        var a = new Assignment
        {
            Title = req.Title,
            Description = req.Description,
            AttachmentUrl = req.AttachmentUrl,
            MaxMarks = req.MaxMarks,
            DueDate = req.DueDate,
            CourseId = req.CourseId,
            CreatedById = req.CreatedById,
            Status = AssignmentStatus.Published
        };
        db.Assignments.Add(a);
        await db.SaveChangesAsync();

        // Notify enrolled students — in-app notification (bell icon) plus email
        var students = await db.Enrollments
            .Include(e => e.User)
            .Where(e => e.CourseId == req.CourseId && e.Status == EnrollmentStatus.Active)
            .Select(e => e.User).ToListAsync();
        var course = await db.Courses.FindAsync(req.CourseId);
        foreach (var s in students)
        {
            _ = email.SendAssignmentNotificationAsync(s.Email, s.FirstName, req.Title, req.DueDate, course?.Title ?? "");
            await NotificationHelper.NotifyAsync(db, s.Id,
                "New assignment posted",
                $"{req.Title} in {course?.Title ?? "your course"} — due {req.DueDate:MMM dd}",
                NotificationType.Assignment,
                $"/dashboard/assignments/{a.Id}");
        }

        return Ok(new { a.Id });
    }

    [HttpPut("{id}")]
    [Authorize(Roles = "SuperAdmin,OrgAdmin,Instructor")]
    public async Task<IActionResult> Update(int id, [FromBody] CreateAssignmentRequest req)
    {
        var a = await db.Assignments.FindAsync(id);
        if (a is null) return NotFound();
        a.Title = req.Title; a.Description = req.Description;
        a.MaxMarks = req.MaxMarks; a.DueDate = req.DueDate;
        a.AttachmentUrl = req.AttachmentUrl;
        await db.SaveChangesAsync();
        return NoContent();
    }

    [HttpDelete("{id}")]
    [Authorize(Roles = "SuperAdmin,OrgAdmin,Instructor")]
    public async Task<IActionResult> Delete(int id)
    {
        var a = await db.Assignments.FindAsync(id);
        if (a is null) return NotFound();
        db.Assignments.Remove(a);
        await db.SaveChangesAsync();
        return NoContent();
    }

    // ─── Student: submit (or resubmit) assignment ──────────────
    // Allows resubmission when the existing submission status is
    // ResubmitRequested — otherwise blocks duplicate submissions.
    [HttpPost("submit")]
    public async Task<IActionResult> Submit([FromBody] SubmitAssignmentRequest req)
    {
        var existing = await db.AssignmentSubmissions
            .FirstOrDefaultAsync(s => s.AssignmentId == req.AssignmentId && s.StudentId == req.StudentId);

        var assignment = await db.Assignments.Include(a => a.Course)
            .FirstOrDefaultAsync(a => a.Id == req.AssignmentId);
        if (assignment is null) return NotFound();
        var isLate = DateTime.UtcNow > assignment.DueDate;

        if (existing is not null)
        {
            // Only allow resubmission if instructor explicitly requested it
            if (existing.Status != SubmissionStatus.ResubmitRequested)
                return BadRequest(new { message = "Already submitted" });

            existing.SubmissionText = req.SubmissionText;
            existing.FileUrl = req.FileUrl;
            existing.SubmittedAt = DateTime.UtcNow;
            existing.Status = isLate ? SubmissionStatus.Late : SubmissionStatus.Submitted;
            existing.MarksObtained = null;   // clear previous grade on resubmission
            existing.Feedback = null;
            existing.GradedAt = null;
            existing.GradedById = null;
            await db.SaveChangesAsync();
            return Ok(new { existing.Id, existing.Status, resubmitted = true });
        }

        var sub = new AssignmentSubmission
        {
            AssignmentId = req.AssignmentId,
            StudentId = req.StudentId,
            SubmissionText = req.SubmissionText,
            FileUrl = req.FileUrl,
            SubmittedAt = DateTime.UtcNow,
            Status = isLate ? SubmissionStatus.Late : SubmissionStatus.Submitted
        };
        db.AssignmentSubmissions.Add(sub);
        await db.SaveChangesAsync();

        // Notify instructor of new submission (best-effort, non-blocking)
        try
        {
            var instructor = await db.Users.FindAsync(assignment.CreatedById);
            var student = await db.Users.FindAsync(req.StudentId);
            if (instructor is not null && student is not null)
                _ = email.SendAssignmentNotificationAsync(instructor.Email, instructor.FirstName,
                    $"New submission: {assignment.Title} from {student.FirstName} {student.LastName}",
                    assignment.DueDate, assignment.Course.Title);
        }
        catch { /* email is non-critical */ }

        return Ok(new { sub.Id, sub.Status });
    }

    // ─── Trainer: grade submission OR request resubmission ─────
    // If req.MarksObtained is null and req.Status == "ResubmitRequested",
    // this sends the student feedback WITHOUT a grade and unlocks resubmission.
    [HttpPost("grade")]
    [Authorize(Roles = "SuperAdmin,OrgAdmin,Instructor")]
    public async Task<IActionResult> Grade([FromBody] GradeSubmissionRequest req)
    {
        var sub = await db.AssignmentSubmissions
            .Include(s => s.Student)
            .Include(s => s.Assignment).ThenInclude(a => a.Course)
            .FirstOrDefaultAsync(s => s.Id == req.SubmissionId);
        if (sub is null) return NotFound();

        var requestingResubmit = string.Equals(req.Status, "ResubmitRequested", StringComparison.OrdinalIgnoreCase);

        sub.Feedback = req.Feedback;
        sub.GradedById = req.GradedById;
        sub.GradedAt = DateTime.UtcNow;

        if (requestingResubmit)
        {
            sub.Status = SubmissionStatus.ResubmitRequested;
            sub.MarksObtained = null;   // no grade yet — student must resubmit
        }
        else
        {
            sub.MarksObtained = req.MarksObtained ?? 0;
            sub.Status = SubmissionStatus.Graded;
        }

        await db.SaveChangesAsync();

        // Notify student (best-effort, non-blocking) — both in-app
        // notification (so the bell icon shows it immediately) and email.
        try
        {
            if (requestingResubmit)
            {
                _ = email.SendAssignmentNotificationAsync(
                    sub.Student.Email, sub.Student.FirstName,
                    $"Resubmission requested: {sub.Assignment.Title} — {req.Feedback}",
                    sub.Assignment.DueDate, sub.Assignment.Course.Title
                );
                await NotificationHelper.NotifyAsync(db, sub.StudentId,
                    "Resubmission requested",
                    $"{sub.Assignment.Title} in {sub.Assignment.Course.Title}: {req.Feedback}",
                    NotificationType.Assignment,
                    $"/dashboard/assignments/{sub.AssignmentId}");
            }
            else
            {
                _ = email.SendGradeNotificationAsync(
                    sub.Student.Email, sub.Student.FirstName,
                    sub.Assignment.Title, sub.MarksObtained ?? 0,
                    sub.Assignment.MaxMarks, req.Feedback ?? "",
                    sub.Assignment.Course.Title
                );
                await NotificationHelper.NotifyAsync(db, sub.StudentId,
                    "Assignment graded",
                    $"You scored {sub.MarksObtained}/{sub.Assignment.MaxMarks} on {sub.Assignment.Title}",
                    NotificationType.Assignment,
                    $"/dashboard/assignments/{sub.AssignmentId}");
            }
        }
        catch { /* notification/email is non-critical */ }

        return Ok(new { sub.MarksObtained, sub.Feedback, sub.Status });
    }

    // ─── Trainer: all submissions for an assignment ────────────
    [HttpGet("{id}/submissions")]
    [Authorize(Roles = "SuperAdmin,OrgAdmin,Instructor")]
    public async Task<IActionResult> GetSubmissions(int id)
    {
        var subs = await db.AssignmentSubmissions
            .Include(s => s.Student)
            .Include(s => s.Assignment)
            .Where(s => s.AssignmentId == id)
            .OrderByDescending(s => s.SubmittedAt)
            .ToListAsync();
        return Ok(subs.Select(MapSub));
    }

    static AssignmentDto MapAssignment(Assignment a, AssignmentSubmission? sub) => new(
        a.Id, a.Title, a.Description, a.AttachmentUrl, a.MaxMarks, a.DueDate,
        a.Status.ToString(), a.CourseId, a.Course.Title,
        a.CreatedById, $"{a.CreatedBy.FirstName} {a.CreatedBy.LastName}",
        a.CreatedAt,
        a.Submissions.Count,
        a.Submissions.Count(s => s.Status == SubmissionStatus.Graded),
        sub?.MarksObtained,
        sub?.Status.ToString() ?? "NotSubmitted",
        sub?.Feedback
    );

    static SubmissionDto MapSub(AssignmentSubmission s) => new(
        s.Id, s.AssignmentId, s.Assignment.Title,
        s.StudentId, $"{s.Student.FirstName} {s.Student.LastName}",
        s.SubmissionText, s.FileUrl, s.MarksObtained, s.Feedback,
        s.Status.ToString(), s.SubmittedAt, s.GradedAt
    );
}