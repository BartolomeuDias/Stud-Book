using Application.DTOs;

namespace Application.Auth
{
    public interface IAuthService
    {
        /// <returns>null, если пользователь с таким email не найден.</returns>
        Task<LoginResult?> LoginAsync(string email, CancellationToken cancellationToken = default);
    }
}