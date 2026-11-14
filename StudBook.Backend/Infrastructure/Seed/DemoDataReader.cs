using System.Reflection;
using System.Text.Json;


namespace Infrastructure.Seed;
/// <summary>Читает вшитый в сборку файл demo_data_v1.json.</summary>
public static class DemoDataReader
{
    private const string ResourceName = "demo_data_v1.json";

    public static JsonDocument Open()
    {
        using var stream = Assembly.GetExecutingAssembly().GetManifestResourceStream(ResourceName)
            ?? throw new InvalidOperationException($"Embedded resource '{ResourceName}' not found.");
        return JsonDocument.Parse(stream);
    }
}