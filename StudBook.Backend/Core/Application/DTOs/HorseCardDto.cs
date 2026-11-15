using StudBook.Domain;

namespace Application.DTOs;

/// <summary>Карточка лошади с родословной (OW-02.2, OW-02.3).</summary>
public record HorseCardDto(
    int Id,
    string Name,
    string Category,
    string Sex,
    string Breed,
    string Color,
    string? DateOfBirth,
    string? RegistrationNumber,
    int? OwnerClientId,
    string? OwnerName,
    string Notes,
    bool IsActive,
    PedigreeDto Pedigree)
{
    public static HorseCardDto From(Horse h)
    {
        var sire = h.Sire;
        var dam = h.Dam;

        var pedigree = new PedigreeDto(
            Sire: PedigreeNodeDto.From(sire),
            Dam: PedigreeNodeDto.From(dam),
            PaternalGrandsire: PedigreeNodeDto.From(sire?.Sire),
            PaternalGranddam: PedigreeNodeDto.From(sire?.Dam),
            MaternalGrandsire: PedigreeNodeDto.From(dam?.Sire),
            MaternalGranddam: PedigreeNodeDto.From(dam?.Dam));

        return new HorseCardDto(
            h.Id,
            h.Name,
            h.Category.ToString(),
            h.Sex.ToString(),
            h.Breed,
            h.Color,
            h.DateOfBirth?.ToString("yyyy-MM-dd"),
            h.RegistrationNumber,
            h.OwnerClientId,
            h.OwnerClient?.Name,
            h.Notes,
            h.IsActive,
            pedigree);
    }
}