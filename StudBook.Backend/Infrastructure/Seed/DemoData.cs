using StudBook.Domain;

namespace Infrastructure.Seed;
/// <summary>Содержимое demo_data_v1.json. Лишние разделы (например, controlPairs) при чтении игнорируются.</summary>
public class DemoData
{
    public List<User> Users { get; set; } = [];
    public List<Client> Clients { get; set; } = [];
    public List<Location> Locations { get; set; } = [];
    public List<Horse> Horses { get; set; } = [];
    public List<HorsePlacement> Placements { get; set; } = [];
    public List<CompatibilityRule> CompatibilityRules { get; set; } = [];
}