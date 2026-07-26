using LMS.API.Data;
using LMS.API.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace LMS.API.Controllers;

[ApiController, Route("api/lang")]
[Authorize]
public class LanguageController(LmsDbContext db) : ControllerBase
{
    // ── GET all languages for an org ─────────────────────────────
    [HttpGet("master")]
    public async Task<IActionResult> GetMaster([FromQuery] int orgId)
    {
        var langs = await db.LangMasters
            .Where(l => l.OrganizationId == orgId)
            .OrderBy(l => l.LangID)
            .Select(l => new { l.LangID, l.LangName, l.LangCode, l.IsActive, l.IsDefault })
            .ToListAsync();
        return Ok(langs);
    }

    // ── GET all translations for a language ───────────────────────
    [HttpGet("trans/{langId}")]
    public async Task<IActionResult> GetTrans(int langId, [FromQuery] int orgId)
    {
        var trans = await db.LangTrans
            .Where(t => t.LangID == langId && t.OrganizationId == orgId)
            .Select(t => new { t.ATS, t.TransKey, t.TransVal })
            .ToListAsync();
        // Return as flat dictionary: { "firstName": "First Name", ... }
        var dict = trans.ToDictionary(t => t.TransKey, t => t.TransVal);
        return Ok(dict);
    }

    // ── GET translations for DEFAULT language ─────────────────────
    [HttpGet("trans/org-default")]
    public async Task<IActionResult> GetDefault([FromQuery] int orgId)
    {
        var def = await db.LangMasters
            .FirstOrDefaultAsync(l => l.OrganizationId == orgId && l.IsDefault && l.IsActive);
        if (def is null) return Ok(new Dictionary<string, string>());

        var trans = await db.LangTrans
            .Where(t => t.LangID == def.LangID && t.OrganizationId == orgId)
            .Select(t => new { t.TransKey, t.TransVal })
            .ToListAsync();
        return Ok(trans.ToDictionary(t => t.TransKey, t => t.TransVal));
    }

    // ── ADD language ──────────────────────────────────────────────
    [HttpPost("master"), Authorize(Roles = "SuperAdmin,OrgAdmin")]
    public async Task<IActionResult> AddLang([FromBody] LangMasterRequest req)
    {
        // If this is set as default, unset all others
        if (req.IsDefault)
            await db.LangMasters
                .Where(l => l.OrganizationId == req.OrganizationId)
                .ExecuteUpdateAsync(s => s.SetProperty(l => l.IsDefault, false));

        var lang = new LangMaster
        {
            LangName = req.LangName,
            LangCode = req.LangCode,
            IsActive = req.IsActive,
            IsDefault = req.IsDefault,
            OrganizationId = req.OrganizationId
        };
        db.LangMasters.Add(lang);
        await db.SaveChangesAsync();
        return Ok(new { message = "Language added", langId = lang.LangID });
    }

    // ── UPDATE language ───────────────────────────────────────────
    [HttpPut("master/{id}"), Authorize(Roles = "SuperAdmin,OrgAdmin")]
    public async Task<IActionResult> UpdateLang(int id, [FromBody] LangMasterRequest req)
    {
        var lang = await db.LangMasters.FindAsync(id);
        if (lang is null) return NotFound();

        if (req.IsDefault)
            await db.LangMasters
                .Where(l => l.OrganizationId == lang.OrganizationId && l.LangID != id)
                .ExecuteUpdateAsync(s => s.SetProperty(l => l.IsDefault, false));

        lang.LangName = req.LangName; lang.LangCode = req.LangCode;
        lang.IsActive = req.IsActive; lang.IsDefault = req.IsDefault;
        await db.SaveChangesAsync();
        return Ok(new { message = "Updated" });
    }

    // ── DELETE language ───────────────────────────────────────────
    [HttpDelete("master/{id}"), Authorize(Roles = "SuperAdmin,OrgAdmin")]
    public async Task<IActionResult> DeleteLang(int id)
    {
        var lang = await db.LangMasters.FindAsync(id);
        if (lang is null) return NotFound();
        if (lang.IsDefault) return BadRequest(new { message = "Cannot delete default language" });
        db.LangMasters.Remove(lang);
        await db.SaveChangesAsync();
        return Ok(new { message = "Deleted" });
    }

    // ── UPSERT translation key/value ──────────────────────────────
    [HttpPost("trans"), Authorize(Roles = "SuperAdmin,OrgAdmin")]
    public async Task<IActionResult> UpsertTrans([FromBody] LangTransRequest req)
    {
        var existing = await db.LangTrans.FirstOrDefaultAsync(t =>
            t.LangID == req.LangID && t.TransKey == req.TransKey && t.OrganizationId == req.OrganizationId);

        if (existing is not null)
        {
            existing.TransVal = req.TransVal;
        }
        else
        {
            db.LangTrans.Add(new LangTrans
            {
                LangID = req.LangID,
                TransKey = req.TransKey,
                TransVal = req.TransVal,
                OrganizationId = req.OrganizationId
            });
        }
        await db.SaveChangesAsync();
        return Ok(new { message = "Saved" });
    }

    // ── BULK upsert (save whole translation table at once) ────────
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
    [HttpDelete("trans/{ats}"), Authorize(Roles = "SuperAdmin,OrgAdmin")]
    public async Task<IActionResult> DeleteTrans(int ats)
    {
        var t = await db.LangTrans.FindAsync(ats);
        if (t is null) return NotFound();
        db.LangTrans.Remove(t);
        await db.SaveChangesAsync();
        return Ok(new { message = "Deleted" });
    }
}

public record LangMasterRequest(
    string LangName, string LangCode,
    bool IsActive, bool IsDefault, int OrganizationId
);
public record LangTransRequest(
    int LangID, string TransKey, string TransVal, int OrganizationId
);
public record BulkTransRequest(
    int LangID, int OrganizationId, Dictionary<string, string> Translations
);