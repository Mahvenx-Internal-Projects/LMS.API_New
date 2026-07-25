using LMS.API.Data;
using LMS.API.Services;
using LMS.API.DTOs;
using LMS.API.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace LMS.API.Controllers;

[ApiController, Route("api/auth")]
public class AuthController(LmsDbContext db, IAuthService auth, IEmailService emailService) : ControllerBase
{
    [HttpPost("login")]
    public async Task<IActionResult> Login([FromBody] LoginRequest req)
    {
        var user = await db.Users
            .Include(u => u.Organization)
            .FirstOrDefaultAsync(u => u.Email == req.Email && u.IsActive);

        if (user is null || !BCrypt.Net.BCrypt.Verify(req.Password, user.PasswordHash))
            return Unauthorized(new { message = "Invalid email or password" });

        user.LastLogin = DateTime.UtcNow;
        await db.SaveChangesAsync();

        var token = auth.GenerateJwt(user);
        var refreshToken = auth.GenerateRefreshToken();

        return Ok(new LoginResponse(
            token,
            refreshToken,
            MapUser(user)
        ));
    }

    [HttpPost("register")]
    public async Task<IActionResult> Register([FromBody] RegisterRequest req)
    {
        if (await db.Users.AnyAsync(u => u.Email == req.Email))
            return BadRequest(new { message = "Email already registered" });

        var org = await db.Organizations.FindAsync(req.OrganizationId);
        if (org is null) return BadRequest(new { message = "Organization not found" });

        var user = new User
        {
            FirstName = req.FirstName,
            LastName = req.LastName,
            Email = req.Email,
            PasswordHash = BCrypt.Net.BCrypt.HashPassword(req.Password),
            Role = UserRole.Student,
            OrganizationId = req.OrganizationId
        };
        db.Users.Add(user);
        await db.SaveChangesAsync();

        user = await db.Users.Include(u => u.Organization).FirstAsync(u => u.Id == user.Id);
        _ = emailService.SendWelcomeEmailAsync(user.Email, user.FirstName, org.Name);
        return Ok(new LoginResponse(auth.GenerateJwt(user), auth.GenerateRefreshToken(), MapUser(user)));
    }

    [HttpGet("me"), Authorize]
    public async Task<IActionResult> Me()
    {
        var id = int.Parse(User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)!.Value);
        var user = await db.Users.Include(u => u.Organization).FirstOrDefaultAsync(u => u.Id == id);
        if (user is null) return NotFound();
        return Ok(MapUser(user));
    }

    [HttpGet("organizations")]
    public async Task<IActionResult> GetOrganizations()
    {
        var orgs = await db.Organizations
            .Where(o => o.IsActive)
            .Select(o => new { o.Id, o.Name, o.Slug, o.LogoUrl })
            .ToListAsync();
        return Ok(orgs);
    }

    static UserDto MapUser(User u) => new(
        u.Id, u.FirstName, u.LastName, u.Email, u.AvatarUrl,
        u.Role.ToString(), u.IsActive, u.CreatedAt, u.LastLogin,
        u.OrganizationId, u.Organization.Name
    );


    // ??? Forgot Password — Step 1: Send OTP ???????????????????????
    [HttpPost("forgot-password")]
    public async Task<IActionResult> ForgotPassword([FromBody] ForgotPasswordRequest req)
    {
        var user = await db.Users.FirstOrDefaultAsync(u => u.Email == req.Email && u.IsActive);
        // Always return OK to prevent email enumeration
        if (user is null) return Ok(new { message = "If that email exists, an OTP has been sent." });

        // Generate 6-digit OTP
        var otp = new Random().Next(100000, 999999).ToString();
        var expires = DateTime.UtcNow.AddMinutes(15);

        // Store OTP on user (reuse existing fields or add new ones)
        user.PasswordResetOtp = otp;
        user.PasswordResetOtpExpires = expires;
        await db.SaveChangesAsync();

        // Send OTP email
        await emailService.SendPasswordResetOtpAsync(user.Email, user.FirstName, otp);
        return Ok(new { message = "OTP sent to your email. Valid for 15 minutes." });
    }

    // ??? Forgot Password — Step 2: Verify OTP ?????????????????????
    [HttpPost("verify-otp")]
    public async Task<IActionResult> VerifyOtp([FromBody] VerifyOtpRequest req)
    {
        var user = await db.Users.FirstOrDefaultAsync(u => u.Email == req.Email && u.IsActive);
        if (user is null) return BadRequest(new { message = "Invalid request" });

        if (user.PasswordResetOtp != req.Otp || user.PasswordResetOtpExpires < DateTime.UtcNow)
            return BadRequest(new { message = "Invalid or expired OTP. Please request a new one." });

        // Issue a short-lived reset token
        var resetToken = Guid.NewGuid().ToString("N");
        user.PasswordResetToken = resetToken;
        user.PasswordResetTokenExpires = DateTime.UtcNow.AddMinutes(10);
        user.PasswordResetOtp = null;
        user.PasswordResetOtpExpires = null;
        await db.SaveChangesAsync();

        return Ok(new { message = "OTP verified", resetToken });
    }

    // ??? Forgot Password — Step 3: Reset Password ?????????????????
    [HttpPost("reset-password")]
    public async Task<IActionResult> ResetPassword([FromBody] ResetPasswordRequest req)
    {
        var user = await db.Users.FirstOrDefaultAsync(u =>
            u.Email == req.Email &&
            u.PasswordResetToken == req.ResetToken &&
            u.IsActive);

        if (user is null || user.PasswordResetTokenExpires < DateTime.UtcNow)
            return BadRequest(new { message = "Invalid or expired reset link. Please start over." });

        if (req.NewPassword.Length < 8)
            return BadRequest(new { message = "Password must be at least 8 characters." });

        user.PasswordHash = BCrypt.Net.BCrypt.HashPassword(req.NewPassword);
        user.PasswordResetToken = null;
        user.PasswordResetTokenExpires = null;
        await db.SaveChangesAsync();

        await emailService.SendPasswordChangedAsync(user.Email, user.FirstName);
        return Ok(new { message = "Password updated successfully. You can now login." });
    }

    // ??? Change Password (logged-in user) ?????????????????????????
    [HttpPost("change-password"), Authorize]
    public async Task<IActionResult> ChangePassword([FromBody] ChangePasswordRequest req)
    {
        var id = int.Parse(User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)!.Value);
        var user = await db.Users.FindAsync(id);
        if (user is null) return NotFound();

        if (!BCrypt.Net.BCrypt.Verify(req.CurrentPassword, user.PasswordHash))
            return BadRequest(new { message = "Current password is incorrect." });

        if (req.NewPassword.Length < 8)
            return BadRequest(new { message = "Password must be at least 8 characters." });

        user.PasswordHash = BCrypt.Net.BCrypt.HashPassword(req.NewPassword);
        await db.SaveChangesAsync();

        await emailService.SendPasswordChangedAsync(user.Email, user.FirstName);
        return Ok(new { message = "Password changed successfully." });
    }

    public record ForgotPasswordRequest(string Email);
    public record VerifyOtpRequest(string Email, string Otp);
    public record ResetPasswordRequest(string Email, string ResetToken, string NewPassword);
    public record ChangePasswordRequest(string CurrentPassword, string NewPassword);
}