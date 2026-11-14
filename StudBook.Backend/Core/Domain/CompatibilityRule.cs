namespace StudBook.Domain;
 
/// <summary>Правило допустимости пары. Единая таблица, по которой идут все проверки.</summary>
public class CompatibilityRule
{
    public int Id { get; set; }
 
    /// <summary>Стабильный код правила, уникален (например, NO_CLOSE_KIN).</summary>
    public string Code { get; set; } = "";
 
    public string Description { get; set; } = "";
 
    /// <summary>Текст причины запрета, который видит пользователь.</summary>
    public string DenialMessage { get; set; } = "";
 
    public bool IsActive { get; set; } = true;
 
    /// <summary>Порядок применения: меньше — раньше.</summary>
    public int Priority { get; set; }
 
    /// <summary>Порог правила (например, число поколений). Null, пока заказчик не передал значение.</summary>
    public int? Threshold { get; set; }
    public string? ThresholdUnit { get; set; }
 
    public RuleSource Source { get; set; } = RuleSource.TeamDraft;
}