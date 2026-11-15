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
            .Include(h => h.Sire)
            .Include(h => h.Dam)
            .FirstOrDefaultAsync(h => h.Id == id, cancellationToken);
}
}