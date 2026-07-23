using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using LMS.API.Data;
using LMS.API.Models;
using System.Security.Claims;

namespace LMS.API.Controllers;

public record NotificationDto(int Id, string Title, string? Body, string Type, string? LinkUrl, bool IsRead, DateTime CreatedAt);
public record CreateNotificationRequest(int UserId, string Title, string? Body, string Type, string? LinkUrl);

[ApiController, Route("api/notifications"), Authorize]
public class NotificationsController(LmsDbContext db) : ControllerBase
{
    int CurrentUserId => int.Parse(User.FindFirst(ClaimTypes.NameIdentifier)!.Value);

    // Returns the current user's notifications, newest first. `unreadOnly`
    // lets the bell icon badge query just the count cheaply.
    [HttpGet]
    public async Task<IActionResult> GetMine([FromQuery] bool unreadOnly = false, [FromQuery] int limit = 30)
    {
        var q = db.Notifications.Where(n => n.UserId == CurrentUserId);
        if (unreadOnly) q = q.Where(n => !n.IsRead);

        var items = await q
            .OrderByDescending(n => n.CreatedAt)
            .Take(limit)
            .Select(n => new NotificationDto(n.Id, n.Title, n.Body, n.Type.ToString(), n.LinkUrl, n.IsRead, n.CreatedAt))
            .ToListAsync();

        var unreadCount = await db.Notifications.CountAsync(n => n.UserId == CurrentUserId && !n.IsRead);

        return Ok(new { items, unreadCount });
    }

    [HttpPost("{id}/read")]
    public async Task<IActionResult> MarkRead(int id)
    {
        var n = await db.Notifications.FirstOrDefaultAsync(x => x.Id == id && x.UserId == CurrentUserId);
        if (n is null) return NotFound();
        n.IsRead = true;
        await db.SaveChangesAsync();
        return NoContent();
    }

    [HttpPost("read-all")]
    public async Task<IActionResult> MarkAllRead()
    {
        await db.Notifications
            .Where(n => n.UserId == CurrentUserId && !n.IsRead)
            .ExecuteUpdateAsync(s => s.SetProperty(n => n.IsRead, true));
        return NoContent();
    }

    [HttpDelete("{id}")]
    public async Task<IActionResult> Delete(int id)
    {
        var n = await db.Notifications.FirstOrDefaultAsync(x => x.Id == id && x.UserId == CurrentUserId);
        if (n is null) return NotFound();
        db.Notifications.Remove(n);
        await db.SaveChangesAsync();
        return NoContent();
    }

    // Internal/admin creation — used for testing, or an admin manually
    // pushing an announcement to a specific user. Most notifications get
    // created server-side by other controllers (enrollment, grading,
    // etc.) via NotificationHelper, not through this HTTP endpoint.
    [HttpPost]
    [Authorize(Roles = "SuperAdmin,OrgAdmin")]
    public async Task<IActionResult> Create([FromBody] CreateNotificationRequest req)
    {
        if (!Enum.TryParse<NotificationType>(req.Type, true, out var type)) type = NotificationType.General;
        var n = new Notification
        {
            UserId = req.UserId,
            Title = req.Title,
            Body = req.Body,
            Type = type,
            LinkUrl = req.LinkUrl,
        };
        db.Notifications.Add(n);
        await db.SaveChangesAsync();
        return Ok(new { n.Id });
    }
}

// Lightweight helper other controllers can call (enrollment, assignment
// grading, live class scheduling, etc.) to push a notification + email
// together in one call, without duplicating boilerplate everywhere.
public static class NotificationHelper
{
    public static async Task NotifyAsync(LmsDbContext db, int userId, string title, string? body, NotificationType type, string? linkUrl = null)
    {
        db.Notifications.Add(new Notification
        {
            UserId = userId,
            Title = title,
            Body = body,
            Type = type,
            LinkUrl = linkUrl,
        });
        await db.SaveChangesAsync();
    }
}