using StudBook.Domain;
using Infrastructure.Persistence;
using Microsoft.EntityFrameworkCore;

namespace StudBook.Infrastructure.Seed;

public class DatabaseSeeder(StudBookDbContext db)
{
    public async Task SeedAsync(CancellationToken cancellationToken = default)
    {
        await db.Database.EnsureCreatedAsync(cancellationToken);

        if (await db.Users.AnyAsync(cancellationToken))
            return;

        db.Users.AddRange(
            new User { Email = "client@test.com", Role = "Client", DisplayName = "Test Client" },
            new User { Email = "staff@test.com", Role = "RanchStaff", DisplayName = "Dusty (Owner)" });

        // TODO: когда в Domain появятся Client/Horse/Location/Placement/CompatibilityRule —
        // заполнять их из DemoDataReader.Open() (clients, horses, locations, placements, compatibilityRules).

        await db.SaveChangesAsync(cancellationToken);
    }
}