using Microsoft.EntityFrameworkCore;
using StudBook.Domain;

namespace Infrastructure.Persistence;
public class StudBookDbContext(DbContextOptions<StudBookDbContext> options) : DbContext(options)
{
    public DbSet<User> Users => Set<User>();
}