using LMS.API.Data;
using LMS.API.Models;
using LMS.API.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace LMS.API.Controllers;

public record BatchEnquiryRequest(
    string Name, string Phone, string? Email,
    string? CourseInterest, int? BatchId, int OrganizationId
);

[ApiController, Route("api/enquiries")]
public class EnquiryController(LmsDbContext db) : ControllerBase
{
    [HttpPost("batch")]
    public async Task<IActionResult> BatchEnquiry([FromBody] BatchEnquiryRequest req)
    {
        var enquiry = new BatchEnquiry
        {
            Name = req.Name,
            Phone = req.Phone,
            Email = req.Email,
            CourseInterest = req.CourseInterest,
            BatchId = req.BatchId,
            OrganizationId = req.OrganizationId,
            CreatedAt = DateTime.UtcNow,
        };
        db.BatchEnquiries.Add(enquiry);
        await db.SaveChangesAsync();

        return Ok(new { message = "Enquiry received! We will contact you shortly." });
    }

    [HttpGet]
    [Authorize(Roles = "SuperAdmin,OrgAdmin")]
    public async Task<IActionResult> GetAll([FromQuery] int? orgId)
    {
        var q = db.BatchEnquiries.Include(e => e.Batch).AsQueryable();
        if (orgId.HasValue) q = q.Where(e => e.OrganizationId == orgId.Value);
        var list = await q.OrderByDescending(e => e.CreatedAt).Take(200).ToListAsync();
        return Ok(list.Select(e => new {
            e.Id,
            e.Name,
            e.Phone,
            e.Email,
            e.CourseInterest,
            batchName = e.Batch?.BatchName,
            e.CreatedAt,
        }));
    }
}