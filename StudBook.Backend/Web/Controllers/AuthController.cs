using Application.Auth;
using Microsoft.AspNetCore.Mvc;
using Web.Contracts;

namespace Web.Controllers;

[ApiController]
[Route("api/auth")]
public class AuthController(IAuthService authService) : ControllerBase
{
    [HttpPost("login")]
    public async Task<IActionResult> Login(LoginRequest request, CancellationToken cancellationToken)
    {
        var result = await authService.LoginAsync(request.Email, cancellationToken);
        return result is null ? Unauthorized() : Ok(result);
    }
}
