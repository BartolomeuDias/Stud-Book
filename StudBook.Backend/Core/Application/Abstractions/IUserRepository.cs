using StudBook.Domain;

namespace Application.Abstractions
{
    public interface IUserRepository
    {
        Task<User?> FindByEmailAsync(string email, CancellationToken cancellationToken = default);
    }
}