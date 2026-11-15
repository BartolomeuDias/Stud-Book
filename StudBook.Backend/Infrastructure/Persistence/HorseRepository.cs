using Application.Abstractions;
using Microsoft.EntityFrameworkCore;
using StudBook.Domain;

namespace Infrastructure.Persistence
{
    public class HorseRepository(StudBookDbContext db) : IHorseRepository
    {
        public async Task<IReadOnlyList<Horse>> ListActiveAsync(
            HorseCategory? category = null,
            CancellationToken cancellationToken = default)
        {
            var query = db.Horses
                .AsNoTracking()
                .Include(h => h.OwnerClient)
                .Where(h => h.IsActive && h.Category != HorseCategory.Ancestor);

            if (category.HasValue)
                query = query.Where(h => h.Category == category.Value);

            return await query
                .OrderBy(h => h.Category)
                .ThenBy(h => h.Name)
                .ToListAsync(cancellationToken);
        }

        public Task<Horse?> GetByIdAsync(int id, CancellationToken cancellationToken = default) =>
        db.Horses
            .AsNoTracking()
            .Include(h => h.OwnerClient)
            .Include(h => h.Sire)!.ThenInclude(s => s!.Sire)
            .Include(h => h.Sire)!.ThenInclude(s => s!.Dam)
            .Include(h => h.Dam)!.ThenInclude(d => d!.Sire)
            .Include(h => h.Dam)!.ThenInclude(d => d!.Dam)
            .FirstOrDefaultAsync(h => h.Id == id, cancellationToken);

        public Task<Horse?> GetTrackedByIdAsync(int id, CancellationToken cancellationToken = default) =>
            db.Horses.FirstOrDefaultAsync(h => h.Id == id, cancellationToken);

        public async Task<Horse> AddAsync(Horse horse, CancellationToken cancellationToken = default)
        {
            db.Horses.Add(horse);
            await db.SaveChangesAsync(cancellationToken);
            return horse;
        }

        public async Task UpdateAsync(Horse horse, CancellationToken cancellationToken = default)
        {
            await db.SaveChangesAsync(cancellationToken);
        }
    }
}