using LMS.API.Data;
using LMS.API.DTOs;
using LMS.API.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace LMS.API.Controllers;

[ApiController, Route("api/dashboard"), Authorize]
public class DashboardController(LmsDbContext db) : ControllerBase
{
    // ════════════════════════════════════════════════════════════════════════
    // SuperAdmin — platform-wide stats across ALL organizations
    // ════════════════════════════════════════════════════════════════════════
    [HttpGet("superadmin")]
    [Authorize(Roles = "SuperAdmin")]
    public async Task<IActionResult> SuperAdminDashboard()
    {
        var totalOrgs = await db.Organizations.CountAsync();
        var activeOrgs = await db.Organizations.CountAsync(o => o.IsActive);
        var totalUsers = await db.Users.CountAsync();
        var totalStudents = await db.Users.CountAsync(u => u.Role == UserRole.Student);
        var totalCourses = await db.Courses.CountAsync();
        var totalEnrollments = await db.Enrollments.CountAsync();
        var totalRevenue = await db.OrderItems
            .Where(oi => oi.Order.Status == OrderStatus.Paid)
            .SumAsync(oi => oi.Price);

        // Recently added students across ALL organizations
        var recentStudents = await db.Users
            .Include(u => u.Organization)
            .Where(u => u.Role == UserRole.Student)
            .OrderByDescending(u => u.CreatedAt)
            .Take(10)
            .Select(u => new {
                u.Id,
                u.FirstName,
                u.LastName,
                u.Email,
                u.CreatedAt,
                organizationName = u.Organization.Name,
                organizationId = u.OrganizationId,
            })
            .ToListAsync();

        // Recently added courses across ALL organizations
        var recentCourses = await db.Courses
            .Include(c => c.Organization)
            .OrderByDescending(c => c.CreatedAt)
            .Take(10)
            .Select(c => new {
                c.Id,
                c.Title,
                c.CreatedAt,
                c.EnrollmentCount,
                organizationName = c.Organization.Name,
                organizationId = c.OrganizationId,
            })
            .ToListAsync();

        // Per-organization breakdown — students, courses, enrollments, revenue
        var orgBreakdown = await db.Organizations
            .Select(o => new {
                o.Id,
                o.Name,
                o.LogoUrl,
                o.PrimaryColor,
                studentCount = db.Users.Count(u => u.OrganizationId == o.Id && u.Role == UserRole.Student),
                courseCount = db.Courses.Count(c => c.OrganizationId == o.Id),
                enrollmentCount = db.Enrollments.Count(e => e.Course.OrganizationId == o.Id),
                revenue = db.OrderItems
                    .Where(oi => oi.Course.OrganizationId == o.Id && oi.Order.Status == OrderStatus.Paid)
                    .Sum(oi => (decimal?)oi.Price) ?? 0,
            })
            .OrderByDescending(o => o.studentCount)
            .ToListAsync();

        // Platform-wide monthly enrollment trend (last 6 months, all orgs combined)
        var sixMonthsAgo = DateTime.UtcNow.AddMonths(-6);
        var monthlyEnrollments = await db.Enrollments
            .Where(e => e.EnrolledAt >= sixMonthsAgo)
            .GroupBy(e => new { e.EnrolledAt.Year, e.EnrolledAt.Month })
            .Select(g => new { g.Key.Year, g.Key.Month, Count = g.Count() })
            .ToListAsync();

        var monthlyRevenue = await db.OrderItems
            .Where(oi => oi.Order.Status == OrderStatus.Paid && oi.Order.CreatedAt >= sixMonthsAgo)
            .GroupBy(oi => new { oi.Order.CreatedAt.Year, oi.Order.CreatedAt.Month })
            .Select(g => new { g.Key.Year, g.Key.Month, Revenue = g.Sum(oi => oi.Price) })
            .ToListAsync();

        var monthLabels = Enumerable.Range(0, 6)
            .Select(i => DateTime.UtcNow.AddMonths(-5 + i))
            .Select(d => new {
                label = d.ToString("MMM"),
                year = d.Year,
                month = d.Month,
                enrollments = monthlyEnrollments.FirstOrDefault(x => x.Year == d.Year && x.Month == d.Month)?.Count ?? 0,
                revenue = monthlyRevenue.FirstOrDefault(x => x.Year == d.Year && x.Month == d.Month)?.Revenue ?? 0,
            })
            .ToList();

        return Ok(new
        {
            totalOrgs,
            activeOrgs,
            totalUsers,
            totalStudents,
            totalCourses,
            totalEnrollments,
            revenue = (double)totalRevenue,
            recentStudents,
            recentCourses,
            orgBreakdown,
            monthlyActivity = monthLabels,
        });
    }

    // ════════════════════════════════════════════════════════════════════════
    // Admin (legacy, kept for compatibility) — basic totals only
    // ════════════════════════════════════════════════════════════════════════
    [HttpGet("admin")]
    [Authorize(Roles = "SuperAdmin")]
    public async Task<IActionResult> AdminDashboard()
    {
        var dto = new AdminDashboardDto(
            await db.Organizations.CountAsync(),
            await db.Users.CountAsync(),
            await db.Courses.CountAsync(),
            await db.Enrollments.CountAsync(),
            []
        );
        return Ok(dto);
    }

    // ════════════════════════════════════════════════════════════════════════
    // OrgAdmin / Instructor — single organization dashboard
    // ════════════════════════════════════════════════════════════════════════
    [HttpGet("org/{orgId}")]
    [Authorize(Roles = "SuperAdmin,OrgAdmin,Instructor")]
    public async Task<IActionResult> OrgDashboard(int orgId)
    {
        var total = await db.Enrollments.CountAsync(e => e.Course.OrganizationId == orgId);
        var completed = await db.Enrollments.CountAsync(e => e.Course.OrganizationId == orgId && e.Status == EnrollmentStatus.Completed);
        var topCourses = await db.Courses
            .Where(c => c.OrganizationId == orgId)
            .Select(c => new CourseStatsDto(
                c.Id, c.Title,
                c.Enrollments.Count,
                c.Enrollments.Count > 0 ? c.Enrollments.Count(e => e.Status == EnrollmentStatus.Completed) * 100.0 / c.Enrollments.Count : 0,
                c.Ratings.Count > 0 ? c.Ratings.Average(r => r.Rating) : 0
            ))
            .OrderByDescending(c => c.Enrollments)
            .Take(5)
            .ToListAsync();

        // Last 6 months enrollment activity
        var sixMonthsAgo = DateTime.UtcNow.AddMonths(-6);
        var monthlyEnrollments = await db.Enrollments
            .Where(e => e.Course.OrganizationId == orgId && e.EnrolledAt >= sixMonthsAgo)
            .GroupBy(e => new { e.EnrolledAt.Year, e.EnrolledAt.Month })
            .Select(g => new { g.Key.Year, g.Key.Month, Count = g.Count() })
            .OrderBy(x => x.Year).ThenBy(x => x.Month)
            .ToListAsync();

        var monthlyRevenue = await db.OrderItems
            .Where(oi => oi.Course.OrganizationId == orgId && oi.Order.Status == OrderStatus.Paid && oi.Order.CreatedAt >= sixMonthsAgo)
            .GroupBy(oi => new { oi.Order.CreatedAt.Year, oi.Order.CreatedAt.Month })
            .Select(g => new { g.Key.Year, g.Key.Month, Revenue = g.Sum(oi => oi.Price) })
            .OrderBy(x => x.Year).ThenBy(x => x.Month)
            .ToListAsync();

        var monthLabels = Enumerable.Range(0, 6)
            .Select(i => DateTime.UtcNow.AddMonths(-5 + i))
            .Select(d => new {
                Label = d.ToString("MMM"),
                Year = d.Year,
                Month = d.Month,
                Enrollments = monthlyEnrollments.FirstOrDefault(x => x.Year == d.Year && x.Month == d.Month)?.Count ?? 0,
                Revenue = monthlyRevenue.FirstOrDefault(x => x.Year == d.Year && x.Month == d.Month)?.Revenue ?? 0
            }).ToList();

        var recentStudents = await db.Users
            .Where(u => u.OrganizationId == orgId && u.Role == UserRole.Student)
            .OrderByDescending(u => u.CreatedAt)
            .Take(5)
            .Select(u => new { u.Id, u.FirstName, u.LastName, u.Email, u.CreatedAt })
            .ToListAsync();

        return Ok(new
        {
            users = await db.Users.CountAsync(u => u.OrganizationId == orgId),
            courses = await db.Courses.CountAsync(c => c.OrganizationId == orgId),
            enrollments = total,
            students = await db.Users.CountAsync(u => u.OrganizationId == orgId && u.Role == UserRole.Student),
            completionRate = total > 0 ? completed * 100.0 / total : 0,
            topCourses,
            monthlyActivity = monthLabels,
            recentStudents,
            revenue = (double)(await db.OrderItems.Where(oi => oi.Course.OrganizationId == orgId && oi.Order.Status == OrderStatus.Paid).SumAsync(oi => oi.Price)),
            activeStudents = await db.LessonProgresses.Where(p => p.UpdatedAt >= DateTime.UtcNow.AddDays(-7) && p.Lesson.Module.Course.OrganizationId == orgId).Select(p => p.UserId).Distinct().CountAsync()
        });
    }

    // ════════════════════════════════════════════════════════════════════════
    // Course-wise enrolled students list — click a course to see who enrolled
    // GET /api/dashboard/org/{orgId}/course/{courseId}/students
    // ════════════════════════════════════════════════════════════════════════
    [HttpGet("org/{orgId}/course/{courseId}/students")]
    [Authorize(Roles = "SuperAdmin,OrgAdmin,Instructor")]
    public async Task<IActionResult> CourseStudents(int orgId, int courseId)
    {
        var course = await db.Courses.FindAsync(courseId);
        if (course is null) return NotFound();

        var students = await db.Enrollments
            .Include(e => e.User)
            .Where(e => e.CourseId == courseId && e.Course.OrganizationId == orgId)
            .OrderByDescending(e => e.EnrolledAt)
            .Select(e => new {
                enrollmentId = e.Id,
                userId = e.UserId,
                name = $"{e.User.FirstName} {e.User.LastName}",
                email = e.User.Email,
                phone = e.User.PhoneNumber,
                enrolledAt = e.EnrolledAt,
                status = e.Status.ToString(),
                progressPercent = e.ProgressPercent,
                completedAt = e.CompletedAt,
                // Exam attempt for this course
                examAttempt = db.MockTestAttempts
                    .Where(a => a.UserId == e.UserId && a.MockTest.CourseId == courseId)
                    .OrderByDescending(a => a.StartedAt)
                    .Select(a => new {
                        attemptId = a.Id,
                        scorePercent = a.ScorePercent,
                        passed = a.Passed,
                        completedAt = a.CompletedAt,
                        status = a.Status.ToString()
                    })
                    .FirstOrDefault()
            })
            .ToListAsync();

        return Ok(new
        {
            courseId,
            courseTitle = course.Title,
            totalEnrolled = students.Count,
            completed = students.Count(s => s.status == "Completed"),
            passed = students.Count(s => s.examAttempt != null && s.examAttempt.passed),
            students
        });
    }
    [HttpGet("student/{userId}")]
    public async Task<IActionResult> StudentDashboard(int userId)
    {
        var totalWatchSecs = await db.LessonProgresses
            .Where(p => p.UserId == userId)
            .SumAsync(p => p.WatchedSeconds);

        // Last 7 days daily watch time — keep raw seconds per day, not
        // pre-truncated to minutes. Summing whole-minute values per lesson
        // (e.g. 25s + 6s = 31s) used to floor-divide to 0 here, which made
        // any session under a minute invisible on the dashboard even though
        // it was correctly saved. The frontend now decides how to format
        // (show "31s" under a minute, "Xm" once it crosses 60s).
        var sevenDaysAgo = DateTime.UtcNow.AddDays(-7);
        var dailyWatch = await db.LessonProgresses
            .Where(p => p.UserId == userId && p.UpdatedAt >= sevenDaysAgo)
            .GroupBy(p => p.UpdatedAt.Date)
            .Select(g => new { Date = g.Key, Seconds = g.Sum(p => p.WatchedSeconds) })
            .OrderBy(x => x.Date)
            .ToListAsync();

        var weekActivity = Enumerable.Range(0, 7)
            .Select(i => DateTime.UtcNow.AddDays(-6 + i).Date)
            .Select(d => {
                var secs = dailyWatch.FirstOrDefault(x => x.Date == d)?.Seconds ?? 0;
                return new
                {
                    label = d.ToString("ddd"),
                    seconds = secs,
                    minutes = secs / 60, // kept for backward compatibility with existing chart code
                };
            }).ToList();

        return Ok(new
        {
            enrolledCourses = await db.Enrollments.CountAsync(e => e.UserId == userId),
            completedCourses = await db.Enrollments.CountAsync(e => e.UserId == userId && e.Status == EnrollmentStatus.Completed),
            certificatesEarned = await db.Certificates.CountAsync(c => c.UserId == userId),
            totalWatchSeconds = totalWatchSecs,
            totalWatchMinutes = totalWatchSecs / 60, // kept for backward compatibility
            weekActivity,
            activeEnrollments = await db.Enrollments
                .Include(e => e.User)
                .Include(e => e.Course)
                .Where(e => e.UserId == userId && e.Status == EnrollmentStatus.Active)
                .OrderByDescending(e => e.EnrolledAt)
                .Select(e => new EnrollmentDto(
                    e.Id, e.UserId, $"{e.User.FirstName} {e.User.LastName}",
                    e.CourseId, e.Course.Title, e.EnrolledAt, e.CompletedAt,
                    e.Status.ToString(), e.ProgressPercent, e.TotalWatchSeconds
                ))
                .Take(5)
                .ToListAsync()
        });
    }
}