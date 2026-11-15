using Application.DTOs;

namespace Application.Services.CompatibilityRules;

public interface ICompatibilityRuleService
{
    Task<IReadOnlyList<CompatibilityRuleDto>> ListAsync(CancellationToken cancellationToken = default);

    Task<CompatibilityRuleDto?> UpdateAsync(
        int id,
        bool? isActive,
        int? priority,
        int? threshold,
        string? thresholdUnit,
        string? source,
        CancellationToken cancellationToken = default);
}