using LMS.API.Data;
using LMS.API.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace LMS.API.Controllers;

[ApiController, Route("api/lang")]
public class LanguageController(LmsDbContext db) : ControllerBase
{
    // ── GET all global languages ──────────────────────────────────
    // Returns LangID=1 English, LangID=2 Telugu, LangID=3 Hindi etc.
    [HttpGet("master")]
    public async Task<IActionResult> GetMaster()
    {
        var langs = await db.LangMasters
            .Where(l => l.IsActive)
            .OrderBy(l => l.LangID)
            .Select(l => new { l.LangID, l.LangName, l.LangCode, l.IsActive })
            .ToListAsync();
        return Ok(langs);
    }

    // ── GET org's language settings ───────────────────────────────
    [HttpGet("org-settings/{orgId}")]
    public async Task<IActionResult> GetOrgSettings(int orgId)
    {
        var settings = await db.OrgLangSettings
            .Where(s => s.OrganizationId == orgId)
            .Include(s => s.Organization)
            .Select(s => new { s.Id, s.LangID, s.IsDefault })
            .ToListAsync();
        return Ok(settings);
    }

    // ── GET default langId for an org ─────────────────────────────
    [HttpGet("org-default-lang/{orgId}")]
    public async Task<IActionResult> GetDefaultLang(int orgId)
    {
        var setting = await db.OrgLangSettings
            .FirstOrDefaultAsync(s => s.OrganizationId == orgId && s.IsDefault);
        // Fallback to LangID=1 (English) if not set
        return Ok(new { langId = setting?.LangID ?? 1 });
    }

    // ── GET translations: LangID + OrgId ─────────────────────────
    // e.g. GET /api/lang/trans/1/2 → English labels for Org 2
    [HttpGet("trans/{langId:int}/{orgId:int}")]
    public async Task<IActionResult> GetTrans(int langId, int orgId)
    {
        var trans = await db.LangTrans
            .Where(t => t.LangID == langId && t.OrganizationId == orgId)
            .Select(t => new { t.TransKey, t.TransVal })
            .ToListAsync();
        return Ok(trans.ToDictionary(t => t.TransKey, t => t.TransVal));
    }

    // ── GET default language translations for an org ──────────────
    // Finds org's default LangID, then fetches translations
    [HttpGet("trans/default/{orgId:int}")]
    public async Task<IActionResult> GetDefault(int orgId)
    {
        // Get org's default language (fallback to LangID=1 = English)
        var setting = await db.OrgLangSettings
            .FirstOrDefaultAsync(s => s.OrganizationId == orgId && s.IsDefault);
        var langId = setting?.LangID ?? 1;

        var trans = await db.LangTrans
            .Where(t => t.LangID == langId && t.OrganizationId == orgId)
            .Select(t => new { t.TransKey, t.TransVal })
            .ToListAsync();

        // If org has no custom translations, fallback to org 1's translations
        if (!trans.Any())
        {
            trans = await db.LangTrans
                .Where(t => t.LangID == langId && t.OrganizationId == 1)
                .Select(t => new { t.TransKey, t.TransVal })
                .ToListAsync();
        }

        return Ok(trans.ToDictionary(t => t.TransKey, t => t.TransVal));
    }

    // ── ADD global language ───────────────────────────────────────
    [HttpPost("master"), Authorize(Roles = "SuperAdmin")]
    public async Task<IActionResult> AddLang([FromBody] LangMasterRequest req)
    {
        if (await db.LangMasters.AnyAsync(l => l.LangCode == req.LangCode))
            return BadRequest(new { message = $"Language '{req.LangCode}' already exists" });

        var lang = new LangMaster
        {
            LangName = req.LangName,
            LangCode = req.LangCode,
            IsActive = true
        };
        db.LangMasters.Add(lang);
        await db.SaveChangesAsync();
        return Ok(new { message = "Language added", langId = lang.LangID });
    }

    // ── SET org default language ──────────────────────────────────
    [HttpPost("org-settings"), Authorize(Roles = "SuperAdmin,OrgAdmin")]
    public async Task<IActionResult> SetOrgLang([FromBody] OrgLangRequest req)
    {
        // Remove existing settings for this org
        var existing = db.OrgLangSettings.Where(s => s.OrganizationId == req.OrganizationId);
        db.OrgLangSettings.RemoveRange(existing);

        db.OrgLangSettings.Add(new OrgLangSetting
        {
            OrganizationId = req.OrganizationId,
            LangID = req.LangID,
            IsDefault = true
        });
        await db.SaveChangesAsync();
        return Ok(new { message = "Org language updated" });
    }

    // ── BULK upsert translations ──────────────────────────────────
    [HttpPost("trans/bulk"), Authorize(Roles = "SuperAdmin,OrgAdmin")]
    public async Task<IActionResult> BulkUpsert([FromBody] BulkTransRequest req)
    {
        foreach (var kv in req.Translations)
        {
            var existing = await db.LangTrans.FirstOrDefaultAsync(t =>
                t.LangID == req.LangID && t.TransKey == kv.Key && t.OrganizationId == req.OrganizationId);
            if (existing is not null)
                existing.TransVal = kv.Value;
            else
                db.LangTrans.Add(new LangTrans
                {
                    LangID = req.LangID,
                    TransKey = kv.Key,
                    TransVal = kv.Value,
                    OrganizationId = req.OrganizationId
                });
        }
        await db.SaveChangesAsync();
        return Ok(new { message = $"Saved {req.Translations.Count} translations" });
    }

    // ── DELETE translation ────────────────────────────────────────
    [HttpDelete("trans/{ats:int}"), Authorize(Roles = "SuperAdmin,OrgAdmin")]
    public async Task<IActionResult> DeleteTrans(int ats)
    {
        var t = await db.LangTrans.FindAsync(ats);
        if (t is null) return NotFound();
        db.LangTrans.Remove(t);
        await db.SaveChangesAsync();
        return Ok(new { message = "Deleted" });
    }
}

public record LangMasterRequest(string LangName, string LangCode);
public record OrgLangRequest(int OrganizationId, int LangID);
public record BulkTransRequest(int LangID, int OrganizationId, Dictionary<string, string> Translations);