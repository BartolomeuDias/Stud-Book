using StudBook.Domain;
using Infrastructure.Persistence;
using Microsoft.EntityFrameworkCore;
using Infrastructure.Seed;

namespace StudBook.Infrastructure.Seed;

public class DatabaseSeeder(StudBookDbContext db)
{
    public async Task SeedAsync(CancellationToken cancellationToken = default)
    {
        await db.Database.MigrateAsync(cancellationToken);
 
        if (await db.Horses.AnyAsync(cancellationToken))
            return;
 
        var data = DemoDataReader.Read();
 
        // Записи в JSON идут «родители раньше детей», id заданы явно.
        db.Users.AddRange(data.Users);
        db.Clients.AddRange(data.Clients);
        db.Locations.AddRange(data.Locations);
        db.Horses.AddRange(data.Horses);
        db.HorsePlacements.AddRange(data.Placements);
        db.CompatibilityRules.AddRange(data.CompatibilityRules);
 
        await db.SaveChangesAsync(cancellationToken);
        await ResetSequencesAsync(cancellationToken);
    }
 
    /// <summary>
    /// Демоданные вставлены с явными Id, поэтому счётчики Id в PostgreSQL надо подвинуть,
    /// иначе первая же новая запись (например, OW-03) упадёт на дубликате ключа.
    /// </summary>
    private async Task ResetSequencesAsync(CancellationToken cancellationToken)
    {
        var entityTypes = new[]
        {
            typeof(User), typeof(Client), typeof(Location),
            typeof(Horse), typeof(HorsePlacement), typeof(CompatibilityRule)
        };
 
        foreach (var type in entityTypes)
        {
            var table = db.Model.FindEntityType(type)!.GetTableName()!; // имя из модели EF, не пользовательский ввод
#pragma warning disable EF1002
            await db.Database.ExecuteSqlRawAsync(
                $"SELECT setval(pg_get_serial_sequence('\"{table}\"', 'Id'), (SELECT MAX(\"Id\") FROM \"{table}\"))",
                cancellationToken);
#pragma warning restore EF1002
        }
    }
}