namespace StudBook.Domain;

public class HorsePlacement
{
    public int Id { get; set; }
 
    public int HorseId { get; set; }
    public Horse? Horse { get; set; }
 
    public int LocationId { get; set; }
    public Location? Location { get; set; }
 
    public DateOnly ArrivedOn { get; set; }
    public DateOnly? LeftOn { get; set; }
 
    /// <summary>Откуда лошадь прибыла на ранчо (свободный текст). Null для перемещений внутри ранчо.</summary>
    public string? Origin { get; set; }
 
    public string Notes { get; set; } = "";
}