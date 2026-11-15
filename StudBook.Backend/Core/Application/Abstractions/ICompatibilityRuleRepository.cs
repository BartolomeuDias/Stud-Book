using StudBook.Domain;

namespace Application.Abstractions;

public interface ICompatibilityRuleRepository
{
    Task<IReadOnlyList<CompatibilityRule>> ListAsync(CancellationToken cancellationToken = default);
    Task<CompatibilityRule?> GetTrackedByIdAsync(int id, CancellationToken cancellationToken = default);
    Task UpdateAsync(CompatibilityRule rule, CancellationToken cancellationToken = default);
}