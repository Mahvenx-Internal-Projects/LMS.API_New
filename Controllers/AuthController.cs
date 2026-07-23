using LMS.API.Data;
using LMS.API.DTOs;
using LMS.API.Models;
using LMS.API.Services;
using LMS.API.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Security.Cryptography;

namespace LMS.API.Controllers;

[ApiController, Route("api/auth")]
public class AuthController(LmsDbContext db, IAuthService auth, IEmailService emailService, ILogger<AuthController> logger) : ControllerBase
{
    [HttpPost("login")]
    public async Task<IActionResult> Login([FromBody] LoginRequest req)
    {
        var user = await db.Users
            .Include(u => u.Organization)
            .Include(u => u.RoleAssignments)
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
            OrganizationId = req.OrganizationId,
            PhoneNumber = req.PhoneNumber,
        };
        db.Users.Add(user);
        await db.SaveChangesAsync();

        user = await db.Users.Include(u => u.Organization).Include(u => u.RoleAssignments).FirstAsync(u => u.Id == user.Id);
        // Send welcome email — fire and forget but log failures
        try { await emailService.SendWelcomeEmailAsync(user.Email, user.FirstName, org.Name); }
        catch (Exception ex) { logger.LogError(ex, "Welcome email failed for {Email}", user.Email); }
        return Ok(new LoginResponse(auth.GenerateJwt(user), auth.GenerateRefreshToken(), MapUser(user)));
    }

    [HttpGet("me"), Authorize]
    public async Task<IActionResult> Me()
    {
        var id = int.Parse(User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)!.Value);
        var user = await db.Users.Include(u => u.Organization).Include(u => u.RoleAssignments).FirstOrDefaultAsync(u => u.Id == id);
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
    [HttpPost("forgot-password")]
    public async Task<IActionResult> ForgotPassword([FromBody] ForgotPasswordRequest request)
    {
        var user = await db.Users
            .FirstOrDefaultAsync(u => u.Email == request.Email && u.IsActive);

        if (user == null)
        {
            return BadRequest(new
            {
                message = "User not found."
            });
        }

        // Generate 6-digit OTP
        var otp = RandomNumberGenerator.GetInt32(100000, 1000000).ToString();

        // Save OTP
        user.ResetOtp = otp;
        user.ResetOtpExpiry = DateTime.UtcNow.AddMinutes(10);

        await db.SaveChangesAsync();

        try
        {
            await emailService.SendOtpAsync(
                user.Email,
                user.FirstName,
                otp);

            return Ok(new
            {
                message = "OTP sent successfully."
            });
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "Failed to send OTP email to {Email}", user.Email);

            return StatusCode(500, new
            {
                message = "Failed to send OTP email."
            });
        }
    }
    [HttpPost("verify-otp")]
    public async Task<IActionResult> VerifyOtp([FromBody] VerifyOtpRequest request)
    {
        var user = await db.Users
            .FirstOrDefaultAsync(u => u.Email == request.Email && u.IsActive);

        if (user == null)
        {
            return BadRequest(new
            {
                message = "User not found."
            });
        }

        if (string.IsNullOrEmpty(user.ResetOtp))
        {
            return BadRequest(new
            {
                message = "OTP not generated."
            });
        }

        if (user.ResetOtp != request.Otp)
        {
            return BadRequest(new
            {
                message = "Invalid OTP."
            });
        }

        if (user.ResetOtpExpiry < DateTime.UtcNow)
        {
            return BadRequest(new
            {
                message = "OTP has expired."
            });
        }

        return Ok(new
        {
            message = "OTP verified successfully."
        });
    }
    [HttpPost("reset-password")]
    public async Task<IActionResult> ResetPassword([FromBody] ResetPasswordRequest request)
    {
        var user = await db.Users
            .FirstOrDefaultAsync(u => u.Email == request.Email && u.IsActive);

        if (user == null)
        {
            return BadRequest(new
            {
                message = "User not found."
            });
        }

        if (string.IsNullOrEmpty(user.ResetOtp))
        {
            return BadRequest(new
            {
                message = "OTP not generated."
            });
        }

        if (user.ResetOtp != request.Otp)
        {
            return BadRequest(new
            {
                message = "Invalid OTP."
            });
        }

        if (user.ResetOtpExpiry < DateTime.UtcNow)
        {
            return BadRequest(new
            {
                message = "OTP has expired."
            });
        }

        // Update password
        user.PasswordHash = BCrypt.Net.BCrypt.HashPassword(request.NewPassword);

        // Clear OTP
        user.ResetOtp = null;
        user.ResetOtpExpiry = null;

        await db.SaveChangesAsync();

        return Ok(new
        {
            message = "Password reset successfully."
        });
    }
}