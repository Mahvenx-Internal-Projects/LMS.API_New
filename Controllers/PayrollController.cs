using LMS.API.Data;
using LMS.API.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace LMS.API.Controllers;

[ApiController, Route("api/payroll")]
[Authorize]
public class PayrollController(LmsDbContext db) : ControllerBase
{
    [HttpGet]
    public async Task<IActionResult> GetAll(
        [FromQuery] int? orgId, [FromQuery] string? search,
        [FromQuery] string? status, [FromQuery] string? domain)
    {
        var q = db.PayrollRecords.AsQueryable();
        if (orgId.HasValue) q = q.Where(r => r.OrganizationId == orgId.Value);
        if (!string.IsNullOrEmpty(status) && status != "All")
            q = q.Where(r => r.Status.ToString() == status);
        if (!string.IsNullOrEmpty(domain) && domain != "All")
            q = q.Where(r => r.Domain == domain);
        if (!string.IsNullOrEmpty(search))
            q = q.Where(r => r.FullName.Contains(search) || r.Email.Contains(search) ||
                             r.Phone.Contains(search) || (r.PANCard != null && r.PANCard.Contains(search)));
        var list = await q.OrderByDescending(r => r.CreatedAt).Select(r => new {
            r.Id,
            r.FullName,
            r.Email,
            r.Phone,
            r.Address,
            r.Designation,
            r.Department,
            r.Domain,
            joiningDate = r.JoiningDate,
            r.CTC,
            r.GrossSalary,
            r.BasicSalary,
            r.HRA,
            r.ConveyanceAllowance,
            r.SpecialAllowance,
            pfRequired = r.PFRequired.ToString(),
            r.PFNumber,
            r.PFEmployee,
            r.PFEmployer,
            r.TDS,
            r.ProfessionTax,
            r.OtherDeductions,
            r.TotalDeductions,
            r.NetSalary,
            gstApplicable = r.GSTApplicable.ToString(),
            r.GSTAmount,
            r.PayrollFromDate,
            r.PayrollToDate,
            r.PaymentDay,
            r.BankName,
            r.AccountNumber,
            r.IFSCCode,
            r.AccountHolderName,
            r.BankBranch,
            r.PANCard,
            r.AadharCard,
            r.AdditionalDocuments,
            status = r.Status.ToString(),
            r.Notes,
            r.OrganizationId,
            r.CreatedAt
        }).ToListAsync();
        return Ok(list);
    }

    [HttpGet("{id}")]
    public async Task<IActionResult> Get(int id)
    {
        var r = await db.PayrollRecords.FindAsync(id);
        if (r is null) return NotFound();
        return Ok(new
        {
            r.Id,
            r.FullName,
            r.Email,
            r.Phone,
            r.Address,
            r.Designation,
            r.Department,
            r.Domain,
            joiningDate = r.JoiningDate,
            r.CTC,
            r.GrossSalary,
            r.BasicSalary,
            r.HRA,
            r.ConveyanceAllowance,
            r.SpecialAllowance,
            pfRequired = r.PFRequired.ToString(),
            r.PFNumber,
            r.PFEmployee,
            r.PFEmployer,
            r.TDS,
            r.ProfessionTax,
            r.OtherDeductions,
            r.TotalDeductions,
            r.NetSalary,
            gstApplicable = r.GSTApplicable.ToString(),
            r.GSTAmount,
            r.PayrollFromDate,
            r.PayrollToDate,
            r.PaymentDay,
            r.BankName,
            r.AccountNumber,
            r.IFSCCode,
            r.AccountHolderName,
            r.BankBranch,
            r.PANCard,
            r.AadharCard,
            r.AdditionalDocuments,
            status = r.Status.ToString(),
            r.Notes,
            r.OrganizationId,
            r.CreatedAt
        });
    }

    [HttpPost]
    [Authorize(Roles = "SuperAdmin,OrgAdmin")]
    public async Task<IActionResult> Create([FromBody] PayrollRequest req)
    {
        Enum.TryParse<PFRequired>(req.PFRequired ?? "No", out var pf);
        Enum.TryParse<GSTApplicable>(req.GSTApplicable ?? "No", out var gst);
        var r = new PayrollRecord
        {
            FullName = req.FullName,
            Email = req.Email,
            Phone = req.Phone,
            Address = req.Address,
            Designation = req.Designation,
            Department = req.Department,
            Domain = req.Domain,
            JoiningDate = req.JoiningDate,
            CTC = req.CTC,
            GrossSalary = req.GrossSalary,
            BasicSalary = req.BasicSalary,
            HRA = req.HRA,
            ConveyanceAllowance = req.ConveyanceAllowance,
            SpecialAllowance = req.SpecialAllowance,
            PFRequired = pf,
            PFNumber = req.PFNumber,
            PFEmployee = req.PFEmployee,
            PFEmployer = req.PFEmployer,
            TDS = req.TDS,
            ProfessionTax = req.ProfessionTax,
            OtherDeductions = req.OtherDeductions,
            TotalDeductions = req.TotalDeductions,
            NetSalary = req.NetSalary,
            GSTApplicable = gst,
            GSTAmount = req.GSTAmount,
            PayrollFromDate = req.PayrollFromDate,
            PayrollToDate = req.PayrollToDate,
            PaymentDay = req.PaymentDay,
            BankName = req.BankName,
            AccountNumber = req.AccountNumber,
            IFSCCode = req.IFSCCode,
            AccountHolderName = req.AccountHolderName,
            BankBranch = req.BankBranch,
            PANCard = req.PANCard,
            AadharCard = req.AadharCard,
            AdditionalDocuments = req.AdditionalDocuments,
            Status = PayrollStatus.Active,
            Notes = req.Notes,
            OrganizationId = req.OrganizationId,
            CreatedAt = DateTime.UtcNow,
            UpdatedAt = DateTime.UtcNow
        };
        db.PayrollRecords.Add(r);
        await db.SaveChangesAsync();
        return Ok(new { message = "Payroll record created", id = r.Id });
    }

    [HttpPut("{id}")]
    [Authorize(Roles = "SuperAdmin,OrgAdmin")]
    public async Task<IActionResult> Update(int id, [FromBody] PayrollRequest req)
    {
        var r = await db.PayrollRecords.FindAsync(id);
        if (r is null) return NotFound();
        Enum.TryParse<PFRequired>(req.PFRequired ?? "No", out var pf);
        Enum.TryParse<GSTApplicable>(req.GSTApplicable ?? "No", out var gst);
        Enum.TryParse<PayrollStatus>(req.Status ?? "Active", out var st);
        r.FullName = req.FullName; r.Email = req.Email; r.Phone = req.Phone;
        r.Address = req.Address; r.Designation = req.Designation; r.Department = req.Department;
        r.Domain = req.Domain; r.JoiningDate = req.JoiningDate;
        r.CTC = req.CTC; r.GrossSalary = req.GrossSalary; r.BasicSalary = req.BasicSalary;
        r.HRA = req.HRA; r.ConveyanceAllowance = req.ConveyanceAllowance; r.SpecialAllowance = req.SpecialAllowance;
        r.PFRequired = pf; r.PFNumber = req.PFNumber; r.PFEmployee = req.PFEmployee; r.PFEmployer = req.PFEmployer;
        r.TDS = req.TDS; r.ProfessionTax = req.ProfessionTax; r.OtherDeductions = req.OtherDeductions;
        r.TotalDeductions = req.TotalDeductions; r.NetSalary = req.NetSalary;
        r.GSTApplicable = gst; r.GSTAmount = req.GSTAmount;
        r.PayrollFromDate = req.PayrollFromDate; r.PayrollToDate = req.PayrollToDate; r.PaymentDay = req.PaymentDay;
        r.BankName = req.BankName; r.AccountNumber = req.AccountNumber; r.IFSCCode = req.IFSCCode;
        r.AccountHolderName = req.AccountHolderName; r.BankBranch = req.BankBranch;
        r.PANCard = req.PANCard; r.AadharCard = req.AadharCard; r.AdditionalDocuments = req.AdditionalDocuments;
        r.Status = st; r.Notes = req.Notes; r.UpdatedAt = DateTime.UtcNow;
        await db.SaveChangesAsync();
        return Ok(new { message = "Updated" });
    }

    [HttpDelete("{id}")]
    [Authorize(Roles = "SuperAdmin,OrgAdmin")]
    public async Task<IActionResult> Delete(int id)
    {
        var r = await db.PayrollRecords.FindAsync(id);
        if (r is null) return NotFound();
        db.PayrollRecords.Remove(r); await db.SaveChangesAsync();
        return Ok(new { message = "Deleted" });
    }

    [HttpGet("stats")]
    public async Task<IActionResult> Stats([FromQuery] int? orgId)
    {
        var q = db.PayrollRecords.AsQueryable();
        if (orgId.HasValue) q = q.Where(r => r.OrganizationId == orgId.Value);
        var all = await q.ToListAsync();
        return Ok(new
        {
            total = all.Count,
            active = all.Count(r => r.Status == PayrollStatus.Active),
            inactive = all.Count(r => r.Status == PayrollStatus.Inactive),
            onHold = all.Count(r => r.Status == PayrollStatus.OnHold),
            totalCTC = all.Where(r => r.Status == PayrollStatus.Active).Sum(r => r.CTC),
            totalNetSalary = all.Where(r => r.Status == PayrollStatus.Active).Sum(r => r.NetSalary ?? 0),
            pfEnrolled = all.Count(r => r.PFRequired == PFRequired.Yes),
        });
    }
}

public record PayrollRequest(
    string FullName, string Email, string Phone,
    string? Address, string? Designation, string? Department, string? Domain,
    DateTime? JoiningDate,
    decimal CTC,
    decimal? GrossSalary, decimal? BasicSalary, decimal? HRA,
    decimal? ConveyanceAllowance, decimal? SpecialAllowance,
    string? PFRequired, string? PFNumber,
    decimal? PFEmployee, decimal? PFEmployer,
    decimal? TDS, decimal? ProfessionTax, decimal? OtherDeductions,
    decimal? TotalDeductions, decimal? NetSalary,
    string? GSTApplicable, decimal? GSTAmount,
    DateTime PayrollFromDate, DateTime? PayrollToDate, int PaymentDay,
    string? BankName, string? AccountNumber, string? IFSCCode,
    string? AccountHolderName, string? BankBranch,
    string? PANCard, string? AadharCard, string? AdditionalDocuments,
    string? Status, string? Notes, int OrganizationId
);