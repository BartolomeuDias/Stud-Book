namespace Web.Contracts;

public class CreateHorseRequest
{
    public string Name { get; set; } = "";
    /// <summary>OwnStallion | ManagedStallion | ClientHorse</summary>
    public string Category { get; set; } = "";
    /// <summary>Stallion | Mare | Gelding</summary>
    public string Sex { get; set; } = "";
    public string Breed { get; set; } = "";
    public string Color { get; set; } = "";
    /// <summary>yyyy-MM-dd</summary>
    public string? DateOfBirth { get; set; }
    public string? RegistrationNumber { get; set; }
    public int? OwnerClientId { get; set; }
    public int? SireId { get; set; }
    public int? DamId { get; set; }
    public string Notes { get; set; } = "";
}