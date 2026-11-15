using System.Reflection;
using System.Text.Json;
using System.Text.Json.Serialization;


namespace Infrastructure.Seed;
/// <summary>Читает вшитый в сборку файл demo_data_v1.json.</summary>
public static class DemoDataReader
{
    private const string ResourceName = "demo_data_v1.json";
 
    private static readonly JsonSerializerOptions Options = new()
    {
        PropertyNameCaseInsensitive = true,
        Converters = { new JsonStringEnumConverter() }
    };
 
    public static DemoData Read()
    {
        using var stream = Assembly.GetExecutingAssembly().GetManifestResourceStream(ResourceName)
            ?? throw new InvalidOperationException($"Embedded resource '{ResourceName}' not found.");
 
        return JsonSerializer.Deserialize<DemoData>(stream, Options)
            ?? throw new InvalidOperationException($"'{ResourceName}' is empty.");
    }
}