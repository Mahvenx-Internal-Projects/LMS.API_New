using LMS.API.Data;
using LMS.API.Models;
using LMS.API.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Text.Json;

namespace LMS.API.Controllers;

[ApiController, Route("api/bench")]
[Authorize]
public class BenchResourcesController(LmsDbContext db, ICloudflareService r2) : ControllerBase
{
    // ── helper to build select projection ────────────────────────────────────
    static object Project(BenchResource r) => new
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
        r.ProfilePhotoUrl,
        r.ResumeUrl,
        r.ResumeFileName,
        r.PanCardUrl,
        r.PanCardNumber,
        r.AadhaarUrl,
        r.AadhaarNumber,
        r.OtherDocumentsJson,
        r.OrganizationId,
        r.CreatedAt,
        r.UpdatedAt
    };

    // GET /api/bench
    [HttpGet]
    public async Task<IActionResult> GetAll(
        [FromQuery] int? orgId, [FromQuery] string? domain,
        [FromQuery] string? search, [FromQuery] string? status,
        [FromQuery] string? type)
    {
        var q = db.BenchResources.AsQueryable();
        if (orgId.HasValue) q = q.Where(r => r.OrganizationId == orgId.Value);
        if (!string.IsNullOrEmpty(domain) && domain != "All") q = q.Where(r => r.Domain.ToString() == domain);
        if (!string.IsNullOrEmpty(status) && status != "All") q = q.Where(r => r.Status.ToString() == status);
        if (!string.IsNullOrEmpty(type) && type != "All") q = q.Where(r => r.CandidateType.ToString() == type);
        if (!string.IsNullOrEmpty(search))
            q = q.Where(r => r.Name.Contains(search) || r.Email.Contains(search) ||
                              r.Phone.Contains(search) || r.SkillSet.Contains(search) ||
                              r.CurrentLocation.Contains(search) || r.PreparedLocation.Contains(search));

        var list = await q.OrderByDescending(r => r.CreatedAt).ToListAsync();
        return Ok(list.Select(Project));
    }

    // GET /api/bench/{id}
    [HttpGet("{id}")]
    public async Task<IActionResult> Get(int id)
    {
        var r = await db.BenchResources.FindAsync(id);
        return r is null ? NotFound() : Ok(Project(r));
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
            PanCardNumber = req.PanCardNumber,
            AadhaarNumber = req.AadhaarNumber,
            OrganizationId = req.OrganizationId,
            CreatedAt = DateTime.UtcNow,
            UpdatedAt = DateTime.UtcNow
        };
        db.BenchResources.Add(resource);
        await db.SaveChangesAsync();
        return Ok(new { message = "Resource added", id = resource.Id });
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

        r.Name = req.Name; r.Email = req.Email; r.Phone = req.Phone;
        r.CandidateType = candidateType; r.ExperienceYears = req.ExperienceYears;
        r.CurrentLocation = req.CurrentLocation; r.PreferredLocation = req.PreferredLocation;
        r.PreparedLocation = req.PreparedLocation; r.SkillSet = req.SkillSet;
        r.Domain = domain; r.Status = status;
        r.CurrentCTC = req.CurrentCTC; r.ExpectedCTC = req.ExpectedCTC;
        r.Notes = req.Notes; r.PanCardNumber = req.PanCardNumber;
        r.AadhaarNumber = req.AadhaarNumber;
        r.UpdatedAt = DateTime.UtcNow;
        await db.SaveChangesAsync();
        return Ok(new { message = "Updated" });
    }

    // DELETE /api/bench/{id}
    [HttpDelete("{id}")]
    [Authorize(Roles = "SuperAdmin,OrgAdmin")]
    public async Task<IActionResult> Delete(int id)
    {
        var r = await db.BenchResources.FindAsync(id);
        if (r is null) return NotFound();
        // Clean up R2 files
        if (!string.IsNullOrEmpty(r.ProfilePhotoKey)) await r2.DeleteFileAsync(r.ProfilePhotoKey);
        if (!string.IsNullOrEmpty(r.ResumeKey)) await r2.DeleteFileAsync(r.ResumeKey);
        if (!string.IsNullOrEmpty(r.PanCardKey)) await r2.DeleteFileAsync(r.PanCardKey);
        if (!string.IsNullOrEmpty(r.AadhaarKey)) await r2.DeleteFileAsync(r.AadhaarKey);
        db.BenchResources.Remove(r);
        await db.SaveChangesAsync();
        return Ok(new { message = "Deleted" });
    }

    // ── FILE UPLOAD ENDPOINTS ────────────────────────────────────────────────
    // POST /api/bench/{id}/upload/photo
    [HttpPost("{id}/upload/photo")]
    [Authorize(Roles = "SuperAdmin,OrgAdmin,Instructor")]
    public async Task<IActionResult> UploadPhoto(int id, IFormFile file)
    {
        var r = await db.BenchResources.FindAsync(id);
        if (r is null) return NotFound();

        // Delete old photo
        if (!string.IsNullOrEmpty(r.ProfilePhotoKey))
            await r2.DeleteFileAsync(r.ProfilePhotoKey);

        var folder = $"{r.OrganizationId}/bench/photos";
        var result = await r2.UploadImageAsync(file, folder);
        if (!result.Success) return BadRequest(new { message = result.Error });

        r.ProfilePhotoUrl = result.Url;
        r.ProfilePhotoKey = result.FileKey;
        r.UpdatedAt = DateTime.UtcNow;
        await db.SaveChangesAsync();
        return Ok(new { url = result.Url, key = result.FileKey });
    }

    // POST /api/bench/{id}/upload/resume
    [HttpPost("{id}/upload/resume")]
    [Authorize(Roles = "SuperAdmin,OrgAdmin,Instructor")]
    public async Task<IActionResult> UploadResume(int id, IFormFile file)
    {
        var r = await db.BenchResources.FindAsync(id);
        if (r is null) return NotFound();

        if (!string.IsNullOrEmpty(r.ResumeKey))
            await r2.DeleteFileAsync(r.ResumeKey);

        var folder = $"{r.OrganizationId}/bench/cvs";
        var result = await r2.UploadFileAsync(file, folder);
        if (!result.Success) return BadRequest(new { message = result.Error });

        r.ResumeUrl = result.Url;
        r.ResumeKey = result.FileKey;
        r.ResumeFileName = file.FileName;
        r.UpdatedAt = DateTime.UtcNow;
        await db.SaveChangesAsync();
        return Ok(new { url = result.Url, key = result.FileKey, fileName = file.FileName });
    }

    // POST /api/bench/{id}/upload/pan
    [HttpPost("{id}/upload/pan")]
    [Authorize(Roles = "SuperAdmin,OrgAdmin,Instructor")]
    public async Task<IActionResult> UploadPan(int id, IFormFile file)
    {
        var r = await db.BenchResources.FindAsync(id);
        if (r is null) return NotFound();

        if (!string.IsNullOrEmpty(r.PanCardKey))
            await r2.DeleteFileAsync(r.PanCardKey);

        var folder = $"{r.OrganizationId}/bench/docs";
        var result = await r2.UploadFileAsync(file, folder);
        if (!result.Success) return BadRequest(new { message = result.Error });

        r.PanCardUrl = result.Url;
        r.PanCardKey = result.FileKey;
        r.UpdatedAt = DateTime.UtcNow;
        await db.SaveChangesAsync();
        return Ok(new { url = result.Url, key = result.FileKey });
    }

    // POST /api/bench/{id}/upload/aadhaar
    [HttpPost("{id}/upload/aadhaar")]
    [Authorize(Roles = "SuperAdmin,OrgAdmin,Instructor")]
    public async Task<IActionResult> UploadAadhaar(int id, IFormFile file)
    {
        var r = await db.BenchResources.FindAsync(id);
        if (r is null) return NotFound();

        if (!string.IsNullOrEmpty(r.AadhaarKey))
            await r2.DeleteFileAsync(r.AadhaarKey);

        var folder = $"{r.OrganizationId}/bench/docs";
        var result = await r2.UploadFileAsync(file, folder);
        if (!result.Success) return BadRequest(new { message = result.Error });

        r.AadhaarUrl = result.Url;
        r.AadhaarKey = result.FileKey;
        r.UpdatedAt = DateTime.UtcNow;
        await db.SaveChangesAsync();
        return Ok(new { url = result.Url, key = result.FileKey });
    }

    // POST /api/bench/{id}/upload/doc  — any other document
    [HttpPost("{id}/upload/doc")]
    [Authorize(Roles = "SuperAdmin,OrgAdmin,Instructor")]
    public async Task<IActionResult> UploadDoc(int id, IFormFile file, [FromQuery] string docName = "Document")
    {
        var r = await db.BenchResources.FindAsync(id);
        if (r is null) return NotFound();

        var folder = $"{r.OrganizationId}/bench/docs";
        var result = await r2.UploadFileAsync(file, folder);
        if (!result.Success) return BadRequest(new { message = result.Error });

        // Append to OtherDocumentsJson
        var docs = string.IsNullOrEmpty(r.OtherDocumentsJson)
            ? new List<OtherDoc>()
            : JsonSerializer.Deserialize<List<OtherDoc>>(r.OtherDocumentsJson) ?? [];

        docs.Add(new OtherDoc(docName, result.Url, result.FileKey, file.FileName, DateTime.UtcNow));
        r.OtherDocumentsJson = JsonSerializer.Serialize(docs);
        r.UpdatedAt = DateTime.UtcNow;
        await db.SaveChangesAsync();
        return Ok(new { url = result.Url, key = result.FileKey, name = docName });
    }

    // DELETE /api/bench/{id}/doc/{key} — remove one other document
    [HttpDelete("{id}/doc")]
    [Authorize(Roles = "SuperAdmin,OrgAdmin,Instructor")]
    public async Task<IActionResult> DeleteDoc(int id, [FromQuery] string key)
    {
        var r = await db.BenchResources.FindAsync(id);
        if (r is null) return NotFound();

        await r2.DeleteFileAsync(key);
        var docs = string.IsNullOrEmpty(r.OtherDocumentsJson)
            ? new List<OtherDoc>()
            : JsonSerializer.Deserialize<List<OtherDoc>>(r.OtherDocumentsJson) ?? [];
        docs.RemoveAll(d => d.Key == key);
        r.OtherDocumentsJson = JsonSerializer.Serialize(docs);
        r.UpdatedAt = DateTime.UtcNow;
        await db.SaveChangesAsync();
        return Ok(new { message = "Document deleted" });
    }

    // DELETE /api/bench/{id}/upload/{type} — remove photo/resume/pan/aadhaar
    [HttpDelete("{id}/upload/{type}")]
    [Authorize(Roles = "SuperAdmin,OrgAdmin,Instructor")]
    public async Task<IActionResult> DeleteFile(int id, string type)
    {
        var r = await db.BenchResources.FindAsync(id);
        if (r is null) return NotFound();
        switch (type.ToLower())
        {
            case "photo":
                if (!string.IsNullOrEmpty(r.ProfilePhotoKey)) await r2.DeleteFileAsync(r.ProfilePhotoKey);
                r.ProfilePhotoUrl = null; r.ProfilePhotoKey = null; break;
            case "resume":
                if (!string.IsNullOrEmpty(r.ResumeKey)) await r2.DeleteFileAsync(r.ResumeKey);
                r.ResumeUrl = null; r.ResumeKey = null; r.ResumeFileName = null; break;
            case "pan":
                if (!string.IsNullOrEmpty(r.PanCardKey)) await r2.DeleteFileAsync(r.PanCardKey);
                r.PanCardUrl = null; r.PanCardKey = null; break;
            case "aadhaar":
                if (!string.IsNullOrEmpty(r.AadhaarKey)) await r2.DeleteFileAsync(r.AadhaarKey);
                r.AadhaarUrl = null; r.AadhaarKey = null; break;
            default: return BadRequest(new { message = "Unknown file type" });
        }
        r.UpdatedAt = DateTime.UtcNow;
        await db.SaveChangesAsync();
        return Ok(new { message = "Deleted" });
    }

    // GET /api/bench/domains
    [HttpGet("domains")]
    public IActionResult GetDomains() => Ok(Enum.GetNames<BenchDomain>());

    // GET /api/bench/stats
    [HttpGet("stats")]
    public async Task<IActionResult> GetStats([FromQuery] int? orgId)
    {
        var q = db.BenchResources.AsQueryable();
        if (orgId.HasValue) q = q.Where(r => r.OrganizationId == orgId.Value);
        var all = await q.ToListAsync();
        return Ok(new
        {
            total = all.Count,
            available = all.Count(r => r.Status == BenchStatus.Available),
            deployed = all.Count(r => r.Status == BenchStatus.Deployed),
            onHold = all.Count(r => r.Status == BenchStatus.OnHold),
            freshers = all.Count(r => r.CandidateType == CandidateType.Fresher),
            experienced = all.Count(r => r.CandidateType == CandidateType.Experienced),
            withResume = all.Count(r => !string.IsNullOrEmpty(r.ResumeUrl)),
            byDomain = all.GroupBy(r => r.Domain.ToString())
                .Select(g => new { domain = g.Key, count = g.Count() })
                .OrderByDescending(x => x.count)
        });
    }
}

// ── Records ───────────────────────────────────────────────────────────────────
public record BenchResourceRequest(
    string Name, string Email, string Phone,
    string? CandidateType, double ExperienceYears,
    string CurrentLocation, string PreferredLocation, string PreparedLocation,
    string SkillSet, string Domain, string? Status,
    decimal? CurrentCTC, decimal? ExpectedCTC, string? Notes,
    string? PanCardNumber, string? AadhaarNumber,
    int OrganizationId
);

public record OtherDoc(
    string Name, string Url, string Key,
    string FileName, DateTime UploadedAt
);