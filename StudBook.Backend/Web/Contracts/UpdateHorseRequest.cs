namespace Web.Contracts;

public class UpdateHorseRequest
{
    public string Name { get; set; } = "";
    public string Category { get; set; } = "";
    public string Sex { get; set; } = "";
    public string Breed { get; set; } = "";
    public string Color { get; set; } = "";
    public string? DateOfBirth { get; set; }
    public string? RegistrationNumber { get; set; }
    public int? OwnerClientId { get; set; }
    public int? SireId { get; set; }
    public int? DamId { get; set; }
    public string Notes { get; set; } = "";
}