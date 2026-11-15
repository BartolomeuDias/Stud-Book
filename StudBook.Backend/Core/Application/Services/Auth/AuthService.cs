using Application.Abstractions;
using Application.DTOs;

namespace Application.Auth
{
    public class AuthService(IUserRepository users) : IAuthService
    {
        public async Task<LoginResult?> LoginAsync(string email, CancellationToken cancellationToken = default)
        {
            var user = await users.FindByEmailAsync(email, cancellationToken);
            if (user is null)
                return null;

            // Демо-токен. Позже заменить на JWT.
            var token = "demo-token-" + user.Role.ToString().ToLower();
            return new LoginResult(token, UserDto.From(user));
        }
    }
}