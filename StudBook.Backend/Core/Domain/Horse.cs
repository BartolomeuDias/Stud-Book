namespace StudBook.Domain;

public class Horse
{
    public int Id { get; set; }
    public string Name { get; set; } = "";
 
    /// <summary>Номер регистрации в породной ассоциации. Уникален, если указан.</summary>
    public string? RegistrationNumber { get; set; }
 
    public HorseCategory Category { get; set; }
    public HorseSex Sex { get; set; }
    public string Breed { get; set; } = "";
    public string Color { get; set; } = "";
 
    /// <summary>У записей о далёких предках дата рождения может быть неизвестна.</summary>
    public DateOnly? DateOfBirth { get; set; }
 
    /// <summary>Владелец-клиент. Null у собственных жеребцов ранчо и у записей о предках.</summary>
    public int? OwnerClientId { get; set; }
    public Client? OwnerClient { get; set; }
 
    public int? SireId { get; set; }
    public Horse? Sire { get; set; }
 
    public int? DamId { get; set; }
    public Horse? Dam { get; set; }
 
    /// <summary>Запись актуальна. Для предков всегда false.</summary>
    public bool IsActive { get; set; } = true;
 
    public string Notes { get; set; } = "";
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
 
    public ICollection<Horse> SiredOffspring { get; set; } = new List<Horse>();
    public ICollection<Horse> DamOffspring { get; set; } = new List<Horse>();
    public ICollection<HorsePlacement> Placements { get; set; } = new List<HorsePlacement>();
}