using StudBook.Domain;
using Microsoft.EntityFrameworkCore;

namespace Infrastructure.Persistence;
public class StudBookDbContext(DbContextOptions<StudBookDbContext> options) : DbContext(options)
{
    public DbSet<User> Users => Set<User>();
    public DbSet<Client> Clients => Set<Client>();
    public DbSet<Horse> Horses => Set<Horse>();
    public DbSet<Location> Locations => Set<Location>();
    public DbSet<HorsePlacement> HorsePlacements => Set<HorsePlacement>();
    public DbSet<CompatibilityRule> CompatibilityRules => Set<CompatibilityRule>();
 
    protected override void OnModelCreating(ModelBuilder modelBuilder) =>
        modelBuilder.ApplyConfigurationsFromAssembly(typeof(StudBookDbContext).Assembly);
}