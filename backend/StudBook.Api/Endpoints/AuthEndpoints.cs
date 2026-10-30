using Microsoft.EntityFrameworkCore;
using StudBook.Api.Data;
using StudBook.Api.Models;

namespace StudBook.Api.Endpoints;

public static class AuthEndpoints
{
    public static void MapAuthEndpoints(this WebApplication app)
    {
        app.MapPost("/api/auth/login", async (LoginRequest request, AppDbContext db) =>
        {
            var user = await db.Users.FirstOrDefaultAsync(u => u.Email == request.Email);

            if (user is null)
                return Results.Unauthorized();

            return Results.Ok(new
            {
                token = "demo-token-" + user.Role.ToLower(),
                user = new
                {
                    user.Id,
                    user.Email,
                    user.DisplayName,
                    user.Role
                }
            });
        });
    }
}