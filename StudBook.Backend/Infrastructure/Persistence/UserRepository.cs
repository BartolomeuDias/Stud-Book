using Microsoft.EntityFrameworkCore;
using Application.Abstractions;
using StudBook.Domain;

namespace Infrastructure.Persistence;
public class UserRepository(StudBookDbContext db) : IUserRepository
{
    public Task<User?> FindByEmailAsync(string email, CancellationToken cancellationToken = default) =>
        db.Users.FirstOrDefaultAsync(u => u.Email == email, cancellationToken);
}