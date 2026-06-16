using LMS.API.Data;
using LMS.API.DTOs;
using LMS.API.Models;
using LMS.API.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace LMS.API.Controllers;

public record AddAttendeeRequest(int UserId);
public record AddBatchResourceRequest(string Title, string FileUrl, string FileType);

[ApiController, Route("api/liveclasses"), Authorize]
public class LiveClassesController(LmsDbContext db, IEmailService email) : ControllerBase
{
    [HttpGet("course/{courseId}")]
    public async Task<IActionResult> GetByCourse(int courseId)
    {
        var list = await db.LiveClasses
            .Include(l => l.Host)
            .Include(l => l.Course)
            .Where(l => l.CourseId == courseId)
            .OrderBy(l => l.ScheduledAt)
            .ToListAsync();
        return Ok(list.Select(MapClass));
    }

    [HttpGet("upcoming")]
    public async Task<IActionResult> GetUpcoming([FromQuery] int? orgId, [FromQuery] int? studentId)
    {
        var q = db.LiveClasses
            .Include(l => l.Host)
            .Include(l => l.Course)
            .Where(l => l.ScheduledAt >= DateTime.UtcNow && l.Status == LiveClassStatus.Scheduled);

        if (orgId.HasValue) q = q.Where(l => l.Course.OrganizationId == orgId.Value);

        if (studentId.HasValue)
        {
            var enrolledIds = await db.Enrollments
                .Where(e => e.UserId == studentId.Value && e.Status == EnrollmentStatus.Active)
                .Select(e => e.CourseId).ToListAsync();
            q = q.Where(l => enrolledIds.Contains(l.CourseId));
        }

        var list = await q.OrderBy(l => l.ScheduledAt).Take(20).ToListAsync();
        return Ok(list.Select(MapClass));
    }

    [HttpGet("{id}")]
    public async Task<IActionResult> Get(int id)
    {
        var l = await db.LiveClasses
            .Include(l => l.Host).Include(l => l.Course)
            .Include(l => l.Attendees).ThenInclude(a => a.User)
            .FirstOrDefaultAsync(l => l.Id == id);
        return l is null ? NotFound() : Ok(MapClass(l));
    }

    [HttpPost]
    [Authorize(Roles = "SuperAdmin,OrgAdmin,Instructor")]
    public async Task<IActionResult> Create([FromBody] CreateLiveClassRequest req)
    {
        if (!Enum.TryParse<LiveClassPlatform>(req.Platform, out var platform))
            platform = LiveClassPlatform.Zoom;

        var lc = new LiveClass
        {
            Title = req.Title,
            Description = req.Description,
            ScheduledAt = req.ScheduledAt,
            DurationMinutes = req.DurationMinutes,
            Platform = platform,
            MeetingLink = req.MeetingLink,
            MeetingId = req.MeetingId,
            MeetingPassword = req.MeetingPassword,
            CourseId = req.CourseId,
            HostId = req.HostId
        };
        db.LiveClasses.Add(lc);
        await db.SaveChangesAsync();

        // Auto-add enrolled students as attendees
        var enrolledStudents = await db.Enrollments
            .Include(e => e.User)
            .Where(e => e.CourseId == req.CourseId && e.Status == EnrollmentStatus.Active)
            .ToListAsync();

        foreach (var e in enrolledStudents)
            db.LiveClassAttendees.Add(new LiveClassAttendee { LiveClassId = lc.Id, UserId = e.UserId });

        await db.SaveChangesAsync();

        // Send email notifications
        var course = await db.Courses.FindAsync(req.CourseId);
        foreach (var e in enrolledStudents)
        {
            _ = email.SendLiveClassNotificationAsync(
                e.User.Email, e.User.FirstName,
                req.Title, req.ScheduledAt, req.DurationMinutes,
                req.Platform, req.MeetingLink ?? "", req.MeetingId ?? "",
                req.MeetingPassword ?? "", course?.Title ?? ""
            );
        }

        lc.EmailSent = true;
        await db.SaveChangesAsync();

        return Ok(new { lc.Id });
    }

    [HttpPut("{id}")]
    [Authorize(Roles = "SuperAdmin,OrgAdmin,Instructor")]
    public async Task<IActionResult> Update(int id, [FromBody] UpdateLiveClassRequest req)
    {
        var lc = await db.LiveClasses.FindAsync(id);
        if (lc is null) return NotFound();

        if (req.Title is not null) lc.Title = req.Title;
        if (req.Description is not null) lc.Description = req.Description;
        if (req.ScheduledAt.HasValue) lc.ScheduledAt = req.ScheduledAt.Value;
        if (req.DurationMinutes.HasValue) lc.DurationMinutes = req.DurationMinutes.Value;
        if (req.MeetingLink is not null) lc.MeetingLink = req.MeetingLink;
        if (req.RecordingUrl is not null) lc.RecordingUrl = req.RecordingUrl;
        if (req.Status is not null && Enum.TryParse<LiveClassStatus>(req.Status, out var st)) lc.Status = st;

        await db.SaveChangesAsync();
        return NoContent();
    }

    [HttpDelete("{id}")]
    [Authorize(Roles = "SuperAdmin,OrgAdmin,Instructor")]
    public async Task<IActionResult> Delete(int id)
    {
        var lc = await db.LiveClasses.FindAsync(id);
        if (lc is null) return NotFound();
        lc.Status = LiveClassStatus.Cancelled;
        await db.SaveChangesAsync();
        return NoContent();
    }

    // ─── Send reminder email ───────────────────────────────────
    [HttpPost("{id}/remind")]
    [Authorize(Roles = "SuperAdmin,OrgAdmin,Instructor")]
    public async Task<IActionResult> SendReminder(int id)
    {
        var lc = await db.LiveClasses
            .Include(l => l.Course)
            .Include(l => l.Attendees).ThenInclude(a => a.User)
            .FirstOrDefaultAsync(l => l.Id == id);
        if (lc is null) return NotFound();

        foreach (var att in lc.Attendees)
        {
            _ = email.SendLiveClassNotificationAsync(
                att.User.Email, att.User.FirstName,
                lc.Title, lc.ScheduledAt, lc.DurationMinutes,
                lc.Platform.ToString(), lc.MeetingLink ?? "", lc.MeetingId ?? "",
                lc.MeetingPassword ?? "", lc.Course.Title
            );
        }
        lc.ReminderSent = true;
        await db.SaveChangesAsync();
        return Ok(new { sent = lc.Attendees.Count });
    }


    // ─── Get attendees ────────────────────────────────────────
    [HttpGet("{id}/attendees")]
    [Authorize(Roles = "SuperAdmin,OrgAdmin,Instructor")]
    public async Task<IActionResult> GetAttendees(int id)
    {
        var attendees = await db.LiveClassAttendees
            .Include(a => a.User)
            .Where(a => a.LiveClassId == id)
            .Select(a => new {
                a.UserId,
                a.User.FirstName,
                a.User.LastName,
                a.User.Email,
                a.User.AvatarUrl,
            })
            .ToListAsync();
        return Ok(attendees);
    }

    // ─── Add student to batch ────────────────────────────────
    [HttpPost("{id}/attendees")]
    [Authorize(Roles = "SuperAdmin,OrgAdmin,Instructor")]
    public async Task<IActionResult> AddAttendee(int id, [FromBody] AddAttendeeRequest req)
    {
        var lc = await db.LiveClasses.Include(l => l.Course).FirstOrDefaultAsync(l => l.Id == id);
        if (lc is null) return NotFound();

        var user = await db.Users.FindAsync(req.UserId);
        if (user is null) return NotFound(new { message = "User not found" });

        var exists = await db.LiveClassAttendees.AnyAsync(a => a.LiveClassId == id && a.UserId == req.UserId);
        if (!exists)
        {
            db.LiveClassAttendees.Add(new LiveClassAttendee { LiveClassId = id, UserId = req.UserId });
            await db.SaveChangesAsync();
        }

        // Send email notification to the newly added student
        _ = email.SendLiveClassNotificationAsync(
            user.Email, user.FirstName,
            lc.Title, lc.ScheduledAt, lc.DurationMinutes,
            lc.Platform.ToString(), lc.MeetingLink ?? "", lc.MeetingId ?? "",
            lc.MeetingPassword ?? "", lc.Course.Title
        );

        return Ok(new { message = "Student added and notified" });
    }

    // ─── Remove student from batch ────────────────────────────
    [HttpDelete("{id}/attendees/{userId}")]
    [Authorize(Roles = "SuperAdmin,OrgAdmin,Instructor")]
    public async Task<IActionResult> RemoveAttendee(int id, int userId)
    {
        var att = await db.LiveClassAttendees
            .FirstOrDefaultAsync(a => a.LiveClassId == id && a.UserId == userId);
        if (att is null) return NotFound();
        db.LiveClassAttendees.Remove(att);
        await db.SaveChangesAsync();
        return NoContent();
    }

    // ─── Add resource/file to batch ──────────────────────────
    [HttpPost("{id}/resources")]
    [Authorize(Roles = "SuperAdmin,OrgAdmin,Instructor")]
    public async Task<IActionResult> AddResource(int id, [FromBody] AddBatchResourceRequest req)
    {
        var lc = await db.LiveClasses.FindAsync(id);
        if (lc is null) return NotFound();

        var resource = new BatchResource
        {
            LiveClassId = id,
            Title = req.Title,
            FileUrl = req.FileUrl,
            FileType = req.FileType,
            CreatedAt = DateTime.UtcNow
        };
        db.BatchResources.Add(resource);
        await db.SaveChangesAsync();
        return Ok(resource);
    }

    // ─── Get resources for a batch ──────────────────────────
    [HttpGet("{id}/resources")]
    public async Task<IActionResult> GetResources(int id)
    {
        var resources = await db.BatchResources
            .Where(r => r.LiveClassId == id)
            .OrderByDescending(r => r.CreatedAt)
            .ToListAsync();
        return Ok(resources);
    }

    // ─── Delete resource ─────────────────────────────────────
    [HttpDelete("{id}/resources/{resourceId}")]
    [Authorize(Roles = "SuperAdmin,OrgAdmin,Instructor")]
    public async Task<IActionResult> DeleteResource(int id, int resourceId)
    {
        var r = await db.BatchResources.FindAsync(resourceId);
        if (r is null || r.LiveClassId != id) return NotFound();
        db.BatchResources.Remove(r);
        await db.SaveChangesAsync();
        return NoContent();
    }

    static LiveClassDto MapClass(LiveClass l) => new(
        l.Id, l.Title, l.Description, l.ScheduledAt, l.DurationMinutes,
        l.Platform.ToString(), l.MeetingLink, l.MeetingId, l.MeetingPassword,
        l.RecordingUrl, l.Status.ToString(), l.CourseId, l.Course.Title,
        l.HostId, $"{l.Host.FirstName} {l.Host.LastName}",
        l.EmailSent, l.CreatedAt
    );
}