using Domain;

namespace StudBook.Domain;
 
/// <summary>Конкретное место: денник или загон (устав, А-8). Название уникально.</summary>
public class Location
{
    public int Id { get; set; }
    public string Name { get; set; } = "";
    public LocationType Type { get; set; }
 
    public ICollection<HorsePlacement> Placements { get; set; } = new List<HorsePlacement>();
}