using LMS.API.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace LMS.API.Controllers;

public class ImageUploadRequest { public IFormFile File { get; set; } = null!; }
public class VideoUploadRequest { public IFormFile File { get; set; } = null!; }
public class FileUploadRequest { public IFormFile File { get; set; } = null!; }

[ApiController, Route("api/upload"), Authorize]
public class UploadController(ICloudflareService cloudflare, ILogger<UploadController> logger) : ControllerBase
{
    [HttpPost("image")]
    [Consumes("multipart/form-data")]
    [RequestSizeLimit(10 * 1024 * 1024)]           // 10 MB for images
    public async Task<IActionResult> UploadImage([FromForm] ImageUploadRequest request, [FromQuery] string folder = "images")
    {
        var file = request.File;
        if (file == null || file.Length == 0)
            return BadRequest(new { message = "No file provided" });

        var result = await cloudflare.UploadImageAsync(file, folder);
        if (!result.Success)
            return StatusCode(500, new { message = result.Error ?? "Upload failed" });

        logger.LogInformation("Image uploaded: {Url}", result.Url);
        return Ok(new { url = result.Url, key = result.FileKey });
    }

    [HttpPost("video")]
    [Consumes("multipart/form-data")]
    [RequestSizeLimit(2L * 1024 * 1024 * 1024)]    // 2 GB for videos
    [RequestFormLimits(MultipartBodyLengthLimit = 2L * 1024 * 1024 * 1024)]
    public async Task<IActionResult> UploadVideo([FromForm] VideoUploadRequest request, [FromQuery] string folder = "videos")
    {
        var file = request.File;
        if (file == null || file.Length == 0)
            return BadRequest(new { message = "No file provided" });

        var result = await cloudflare.UploadVideoAsync(file, folder);
        if (!result.Success)
            return StatusCode(500, new { message = result.Error ?? "Upload failed" });

        logger.LogInformation("Video uploaded: {Url}", result.Url);
        return Ok(new { url = result.Url, key = result.FileKey });
    }

    // ── Raw-stream video upload (no FormData) ──────────────────────────
    // Large video files sent via multipart/FormData require the browser
    // to fully read the File into memory before it can build the
    // multipart body and start transmitting — for a 250MB+ file this
    // shows as the progress bar sitting at 0% with no network request
    // visible yet, even though nothing is actually broken. Sending the
    // raw file as the literal POST body (Content-Type: video/*, filename
    // in a header) lets the browser start streaming bytes as it reads
    // them instead, removing that pre-upload stall.
    [HttpPost("video/stream")]
    [Consumes("application/octet-stream", "video/mp4", "video/quicktime", "video/webm", "video/x-matroska")]
    [RequestSizeLimit(2L * 1024 * 1024 * 1024)]
    [DisableRequestSizeLimit]
    public async Task<IActionResult> UploadVideoStream([FromQuery] string folder = "videos", [FromQuery] string fileName = "video.mp4")
    {
        if (Request.ContentLength is null or 0)
            return BadRequest(new { message = "No file provided" });

        var contentType = Request.ContentType ?? "application/octet-stream";
        var result = await cloudflare.UploadVideoStreamAsync(Request.Body, Request.ContentLength.Value, fileName, contentType, folder);
        if (!result.Success)
            return StatusCode(500, new { message = result.Error ?? "Upload failed" });

        logger.LogInformation("Video (raw stream) uploaded: {Url}", result.Url);
        return Ok(new { url = result.Url, key = result.FileKey });
    }

    [HttpPost("file")]
    [Consumes("multipart/form-data")]
    [RequestSizeLimit(100 * 1024 * 1024)]          // 100 MB for documents
    public async Task<IActionResult> UploadFile([FromForm] FileUploadRequest request, [FromQuery] string folder = "documents")
    {
        var file = request.File;
        if (file == null || file.Length == 0)
            return BadRequest(new { message = "No file provided" });

        var result = await cloudflare.UploadFileAsync(file, folder);
        if (!result.Success)
            return StatusCode(500, new { message = result.Error ?? "Upload failed" });

        logger.LogInformation("File uploaded: {Url}", result.Url);
        return Ok(new { url = result.Url, key = result.FileKey });
    }

    [HttpDelete]
    [Authorize(Roles = "SuperAdmin,OrgAdmin")]
    public async Task<IActionResult> DeleteFile([FromQuery] string key)
    {
        var ok = await cloudflare.DeleteFileAsync(key);
        return ok ? NoContent() : StatusCode(500, new { message = "Delete failed" });
    }
}