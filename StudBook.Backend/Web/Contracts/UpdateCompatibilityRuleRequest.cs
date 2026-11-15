namespace Web.Contracts;

/// <summary>Частичное обновление правила (активность, порог, источник).</summary>
public class UpdateCompatibilityRuleRequest
{
    public bool? IsActive { get; set; }
    public int? Priority { get; set; }
    public int? Threshold { get; set; }
    /// <summary>Передать пустую строку, чтобы очистить unit.</summary>
    public string? ThresholdUnit { get; set; }
    /// <summary>TeamDraft | CustomerConfirmed</summary>
    public string? Source { get; set; }
}