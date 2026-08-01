using LMS.API.Data;
using LMS.API.Models;
using LMS.API.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace LMS.API.Controllers;

[ApiController, Route("api/course-assign")]
[Authorize(Roles = "SuperAdmin,OrgAdmin,Instructor")]
public class CourseAssignmentController(LmsDbContext db, IEmailService email) : ControllerBase
{
    // ── GET users NOT yet enrolled in a course ──────────────────────────────
    [HttpGet("course/{courseId}/available-users")]
    public async Task<IActionResult> AvailableUsers(int courseId, [FromQuery] int orgId, [FromQuery] string? search)
    {
        var enrolledIds = await db.Enrollments.Where(e => e.CourseId == courseId).Select(e => e.UserId).ToListAsync();
        var q = db.Users.Where(u => u.OrganizationId == orgId && !enrolledIds.Contains(u.Id));
        if (!string.IsNullOrEmpty(search))
            q = q.Where(u => u.FirstName.Contains(search) || u.LastName.Contains(search) || u.Email.Contains(search));
        var users = await q.OrderBy(u => u.FirstName)
            .Select(u => new { u.Id, u.FirstName, u.LastName, u.Email, u.PhoneNumber }).ToListAsync();
        return Ok(users);
    }

    // ── GET users already enrolled in a course ──────────────────────────────
    [HttpGet("course/{courseId}/enrolled-users")]
    public async Task<IActionResult> EnrolledUsers(int courseId, [FromQuery] string? search)
    {
        var q = db.Enrollments.Include(e => e.User).Where(e => e.CourseId == courseId);
        if (!string.IsNullOrEmpty(search))
            q = q.Where(e => e.User.FirstName.Contains(search) || e.User.LastName.Contains(search) || e.User.Email.Contains(search));
        var list = await q.OrderByDescending(e => e.EnrolledAt)
            .Select(e => new {
                enrollmentId = e.Id, userId = e.UserId,
                name = $"{e.User.FirstName} {e.User.LastName}",
                email = e.User.Email, status = e.Status.ToString(),
                progressPct = e.ProgressPercent, enrolledAt = e.EnrolledAt,
            }).ToListAsync();
        return Ok(list);
    }

    // ── GET courses NOT yet assigned to a user ──────────────────────────────
    [HttpGet("user/{userId}/available-courses")]
    public async Task<IActionResult> AvailableCourses(int userId, [FromQuery] int orgId, [FromQuery] string? search)
    {
        var enrolledIds = await db.Enrollments.Where(e => e.UserId == userId).Select(e => e.CourseId).ToListAsync();
        var q = db.Courses.Where(c => c.OrganizationId == orgId && !enrolledIds.Contains(c.Id));
        if (!string.IsNullOrEmpty(search)) q = q.Where(c => c.Title.Contains(search));
        var courses = await q.OrderBy(c => c.Title)
            .Select(c => new { c.Id, c.Title, c.ThumbnailUrl, level = c.Level.ToString(), c.IsFree, c.Price }).ToListAsync();
        return Ok(courses);
    }

    // ── GET courses already assigned to a user ──────────────────────────────
    [HttpGet("user/{userId}/enrolled-courses")]
    public async Task<IActionResult> EnrolledCourses(int userId)
    {
        var list = await db.Enrollments.Include(e => e.Course).Where(e => e.UserId == userId)
            .OrderByDescending(e => e.EnrolledAt)
            .Select(e => new {
                enrollmentId = e.Id, courseId = e.CourseId, title = e.Course.Title,
                thumbnail = e.Course.ThumbnailUrl, status = e.Status.ToString(),
                progressPct = e.ProgressPercent, enrolledAt = e.EnrolledAt,
            }).ToListAsync();
        return Ok(list);
    }

    // ── ASSIGN single ───────────────────────────────────────────────────────
    [HttpPost("assign")]
    public async Task<IActionResult> AssignSingle([FromBody] AssignRequest req)
    {
        var result = await EnrollUser(req.UserId, req.CourseId, req.SendEmail);
        return result.success ? Ok(new { message = result.message }) : BadRequest(new { message = result.message });
    }

    // ── BULK assign multiple users to one course ────────────────────────────
    [HttpPost("bulk-to-course")]
    public async Task<IActionResult> BulkToCourse([FromBody] BulkToCourseRequest req)
    {
        int ok = 0, skip = 0;
        var errors = new List<string>();
        foreach (var uid in req.UserIds)
        {
            var r = await EnrollUser(uid, req.CourseId, req.SendEmail);
            if (r.success) ok++; else { skip++; errors.Add(r.message); }
        }
        return Ok(new { enrolled = ok, skipped = skip, errors, message = $"Enrolled {ok} user(s). Skipped {skip}." });
    }

    // ── BULK assign multiple courses to one user ────────────────────────────
    [HttpPost("bulk-to-user")]
    public async Task<IActionResult> BulkToUser([FromBody] BulkToUserRequest req)
    {
        int ok = 0, skip = 0;
        foreach (var cid in req.CourseIds)
        {
            var r = await EnrollUser(req.UserId, cid, req.SendEmail);
            if (r.success) ok++; else skip++;
        }
        return Ok(new { enrolled = ok, skipped = skip, message = $"Enrolled in {ok} course(s). Skipped {skip}." });
    }

    // ── REMOVE enrollment ───────────────────────────────────────────────────
    [HttpDelete("enrollment/{enrollmentId}")]
    public async Task<IActionResult> Remove(int enrollmentId)
    {
        var e = await db.Enrollments.FindAsync(enrollmentId);
        if (e is null) return NotFound();
        db.Enrollments.Remove(e);
        await db.SaveChangesAsync();
        return Ok(new { message = "Enrollment removed" });
    }

    // ── Internal helper ─────────────────────────────────────────────────────
    private async Task<(bool success, string message)> EnrollUser(int userId, int courseId, bool sendEmail)
    {
        if (await db.Enrollments.AnyAsync(e => e.UserId == userId && e.CourseId == courseId))
            return (false, $"User {userId} already enrolled");

        var user   = await db.Users.Include(u => u.Organization).FirstOrDefaultAsync(u => u.Id == userId);
        var course = await db.Courses.FirstOrDefaultAsync(c => c.Id == courseId);
        if (user is null)   return (false, $"User {userId} not found");
        if (course is null) return (false, $"Course {courseId} not found");

        db.Enrollments.Add(new Enrollment {
            UserId = userId, CourseId = courseId,
            Status = EnrollmentStatus.Active, EnrolledAt = DateTime.UtcNow,
        });
        await db.SaveChangesAsync();

        if (sendEmail && !string.IsNullOrEmpty(user.Email))
            _ = email.SendEnrollmentConfirmationAsync(user.Email, user.FirstName, course.Title, user.Organization?.Name ?? "LMS");

        return (true, $"Enrolled {user.FirstName} {user.LastName} in {course.Title}");
    }
}

public record AssignRequest(int UserId, int CourseId, bool SendEmail = true);
public record BulkToCourseRequest(int CourseId, List<int> UserIds, bool SendEmail = true);
public record BulkToUserRequest(int UserId, List<int> CourseIds, bool SendEmail = true);
