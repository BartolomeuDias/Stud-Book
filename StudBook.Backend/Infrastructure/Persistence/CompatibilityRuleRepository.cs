using Application.Abstractions;
using Microsoft.EntityFrameworkCore;
using StudBook.Domain;

namespace Infrastructure.Persistence;

public class CompatibilityRuleRepository(StudBookDbContext db) : ICompatibilityRuleRepository
{
    public async Task<IReadOnlyList<CompatibilityRule>> ListAsync(
        CancellationToken cancellationToken = default) =>
        await db.CompatibilityRules
            .AsNoTracking()
            .OrderBy(r => r.Priority)
            .ThenBy(r => r.Code)
            .ToListAsync(cancellationToken);

    public Task<CompatibilityRule?> GetTrackedByIdAsync(
        int id,
        CancellationToken cancellationToken = default) =>
        db.CompatibilityRules.FirstOrDefaultAsync(r => r.Id == id, cancellationToken);

    public async Task UpdateAsync(
        CompatibilityRule rule,
        CancellationToken cancellationToken = default) =>
        await db.SaveChangesAsync(cancellationToken);
}