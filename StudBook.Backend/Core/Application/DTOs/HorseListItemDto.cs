using StudBook.Domain;

namespace Application.DTOs;

/// <summary>Краткая карточка лошади для реестра (OW-01).</summary>
public record HorseListItemDto(
    int Id,
    string Name,
    string Category,
    string Sex,
    string Breed,
    string Color,
    string? DateOfBirth,
    string? RegistrationNumber,
    string? OwnerName)
{
    public static HorseListItemDto From(Horse h) => new(
        h.Id,
        h.Name,
        h.Category.ToString(),
        h.Sex.ToString(),
        h.Breed,
        h.Color,
        h.DateOfBirth?.ToString("yyyy-MM-dd"),
        h.RegistrationNumber,
        h.OwnerClient?.Name);
}