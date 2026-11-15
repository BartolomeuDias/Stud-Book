using Application.Abstractions;
using Application.DTOs;
using StudBook.Domain;

namespace Application.Services.CompatibilityRules;

public class CompatibilityRuleService(ICompatibilityRuleRepository rules) : ICompatibilityRuleService
{
    public async Task<IReadOnlyList<CompatibilityRuleDto>> ListAsync(
        CancellationToken cancellationToken = default)
    {
        var list = await rules.ListAsync(cancellationToken);
        return list.Select(CompatibilityRuleDto.From).ToList();
    }

    public async Task<CompatibilityRuleDto?> UpdateAsync(
        int id,
        bool? isActive,
        int? priority,
        int? threshold,
        string? thresholdUnit,
        string? source,
        CancellationToken cancellationToken = default)
    {
        var rule = await rules.GetTrackedByIdAsync(id, cancellationToken);
        if (rule is null)
            return null;

        if (isActive.HasValue)
            rule.IsActive = isActive.Value;

        if (priority.HasValue)
        {
            if (priority.Value < 1)
                throw new ArgumentException("Priority должен быть >= 1.");
            rule.Priority = priority.Value;
        }

        if (threshold.HasValue)
            rule.Threshold = threshold.Value;

        // null в запросе = не трогаем; "" = очистить
        if (thresholdUnit is not null)
            rule.ThresholdUnit = string.IsNullOrWhiteSpace(thresholdUnit)
                ? null
                : thresholdUnit.Trim();

        if (!string.IsNullOrWhiteSpace(source))
        {
            if (!Enum.TryParse<RuleSource>(source, ignoreCase: true, out var parsed))
                throw new ArgumentException("Source: TeamDraft или CustomerConfirmed.");
            rule.Source = parsed;
        }

        await rules.UpdateAsync(rule, cancellationToken);
        return CompatibilityRuleDto.From(rule);
    }
}