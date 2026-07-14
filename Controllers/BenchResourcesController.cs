using LMS.API.Data;
using LMS.API.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace LMS.API.Controllers;

[ApiController, Route("api/bench")]
[Authorize]
public class BenchResourcesController(LmsDbContext db) : ControllerBase
{
    // GET /api/bench?orgId=1&domain=Java&search=john&status=Available&type=Fresher
    [HttpGet]
    public async Task<IActionResult> GetAll(
        [FromQuery] int? orgId,
        [FromQuery] string? domain,
        [FromQuery] string? search,
        [FromQuery] string? status,
        [FromQuery] string? type)
    {
        var query = db.BenchResources.AsQueryable();

        if (orgId.HasValue)
            query = query.Where(r => r.OrganizationId == orgId.Value);

        if (!string.IsNullOrEmpty(domain) && domain != "All")
            query = query.Where(r => r.Domain.ToString() == domain);

        if (!string.IsNullOrEmpty(status) && status != "All")
            query = query.Where(r => r.Status.ToString() == status);

        if (!string.IsNullOrEmpty(type) && type != "All")
            query = query.Where(r => r.CandidateType.ToString() == type);

        if (!string.IsNullOrEmpty(search))
            query = query.Where(r =>
                r.Name.Contains(search) ||
                r.Email.Contains(search) ||
                r.Phone.Contains(search) ||
                r.SkillSet.Contains(search) ||
                r.CurrentLocation.Contains(search) ||
                r.PreparedLocation.Contains(search));

        var result = await query
            .OrderByDescending(r => r.CreatedAt)
            .Select(r => new {
                r.Id,
                r.Name,
                r.Email,
                r.Phone,
                candidateType = r.CandidateType.ToString(),
                r.ExperienceYears,
                r.CurrentLocation,
                r.PreferredLocation,
                r.PreparedLocation,
                r.SkillSet,
                domain = r.Domain.ToString(),
                status = r.Status.ToString(),
                r.CurrentCTC,
                r.ExpectedCTC,
                r.Notes,
                r.OrganizationId,
                r.CreatedAt,
                r.UpdatedAt
            }).ToListAsync();

        return Ok(result);
    }

    // GET /api/bench/{id}
    [HttpGet("{id}")]
    public async Task<IActionResult> Get(int id)
    {
        var r = await db.BenchResources.FindAsync(id);
        if (r is null) return NotFound();
        return Ok(new
        {
            r.Id,
            r.Name,
            r.Email,
            r.Phone,
            candidateType = r.CandidateType.ToString(),
            r.ExperienceYears,
            r.CurrentLocation,
            r.PreferredLocation,
            r.PreparedLocation,
            r.SkillSet,
            domain = r.Domain.ToString(),
            status = r.Status.ToString(),
            r.CurrentCTC,
            r.ExpectedCTC,
            r.Notes,
            r.OrganizationId,
            r.CreatedAt,
            r.UpdatedAt
        });
    }

    // POST /api/bench
    [HttpPost]
    [Authorize(Roles = "SuperAdmin,OrgAdmin,Instructor")]
    public async Task<IActionResult> Create([FromBody] BenchResourceRequest req)
    {
        if (!Enum.TryParse<BenchDomain>(req.Domain, out var domain))
            return BadRequest(new { message = "Invalid domain" });

        Enum.TryParse<CandidateType>(req.CandidateType ?? "Fresher", out var candidateType);

        var resource = new BenchResource
        {
            Name = req.Name,
            Email = req.Email,
            Phone = req.Phone,
            CandidateType = candidateType,
            ExperienceYears = req.ExperienceYears,
            CurrentLocation = req.CurrentLocation,
            PreferredLocation = req.PreferredLocation,
            PreparedLocation = req.PreparedLocation,
            SkillSet = req.SkillSet,
            Domain = domain,
            Status = BenchStatus.Available,
            CurrentCTC = req.CurrentCTC,
            ExpectedCTC = req.ExpectedCTC,
            Notes = req.Notes,
            OrganizationId = req.OrganizationId,
            CreatedAt = DateTime.UtcNow,
            UpdatedAt = DateTime.UtcNow
        };

        db.BenchResources.Add(resource);
        await db.SaveChangesAsync();
        return Ok(new { message = "Resource added successfully", id = resource.Id });
    }

    // PUT /api/bench/{id}
    [HttpPut("{id}")]
    [Authorize(Roles = "SuperAdmin,OrgAdmin,Instructor")]
    public async Task<IActionResult> Update(int id, [FromBody] BenchResourceRequest req)
    {
        var r = await db.BenchResources.FindAsync(id);
        if (r is null) return NotFound();

        if (!Enum.TryParse<BenchDomain>(req.Domain, out var domain))
            return BadRequest(new { message = "Invalid domain" });

        Enum.TryParse<BenchStatus>(req.Status ?? "Available", out var status);
        Enum.TryParse<CandidateType>(req.CandidateType ?? "Fresher", out var candidateType);

        r.Name = req.Name;
        r.Email = req.Email;
        r.Phone = req.Phone;
        r.CandidateType = candidateType;
        r.ExperienceYears = req.ExperienceYears;
        r.CurrentLocation = req.CurrentLocation;
        r.PreferredLocation = req.PreferredLocation;
        r.PreparedLocation = req.PreparedLocation;
        r.SkillSet = req.SkillSet;
        r.Domain = domain;
        r.Status = status;
        r.CurrentCTC = req.CurrentCTC;
        r.ExpectedCTC = req.ExpectedCTC;
        r.Notes = req.Notes;
        r.UpdatedAt = DateTime.UtcNow;

        await db.SaveChangesAsync();
        return Ok(new { message = "Updated successfully" });
    }

    // DELETE /api/bench/{id}
    [HttpDelete("{id}")]
    [Authorize(Roles = "SuperAdmin,OrgAdmin")]
    public async Task<IActionResult> Delete(int id)
    {
        var r = await db.BenchResources.FindAsync(id);
        if (r is null) return NotFound();
        db.BenchResources.Remove(r);
        await db.SaveChangesAsync();
        return Ok(new { message = "Deleted" });
    }

    // GET /api/bench/domains
    [HttpGet("domains")]
    public IActionResult GetDomains() => Ok(Enum.GetNames<BenchDomain>());

    // GET /api/bench/stats?orgId=1
    [HttpGet("stats")]
    public async Task<IActionResult> GetStats([FromQuery] int? orgId)
    {
        var query = db.BenchResources.AsQueryable();
        if (orgId.HasValue) query = query.Where(r => r.OrganizationId == orgId.Value);
        var all = await query.ToListAsync();
        return Ok(new
        {
            total = all.Count,
            available = all.Count(r => r.Status == BenchStatus.Available),
            deployed = all.Count(r => r.Status == BenchStatus.Deployed),
            onHold = all.Count(r => r.Status == BenchStatus.OnHold),
            freshers = all.Count(r => r.CandidateType == CandidateType.Fresher),
            experienced = all.Count(r => r.CandidateType == CandidateType.Experienced),
            byDomain = all.GroupBy(r => r.Domain.ToString())
                .Select(g => new { domain = g.Key, count = g.Count() })
                .OrderByDescending(x => x.count)
        });
    }
}

public record BenchResourceRequest(
    string Name, string Email, string Phone,
    string? CandidateType,
    double ExperienceYears,
    string CurrentLocation,
    string PreferredLocation,
    string PreparedLocation,
    string SkillSet, string Domain,
    string? Status,
    decimal? CurrentCTC,
    decimal? ExpectedCTC,
    string? Notes,
    int OrganizationId
);