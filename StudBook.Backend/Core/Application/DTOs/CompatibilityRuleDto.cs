using StudBook.Domain;

namespace Application.DTOs;

public record CompatibilityRuleDto(
    int Id,
    string Code,
    string Description,
    string DenialMessage,
    bool IsActive,
    int Priority,
    int? Threshold,
    string? ThresholdUnit,
    string Source)
{
    public static CompatibilityRuleDto From(CompatibilityRule r) => new(
        r.Id,
        r.Code,
        r.Description,
        r.DenialMessage,
        r.IsActive,
        r.Priority,
        r.Threshold,
        r.ThresholdUnit,
        r.Source.ToString());
}