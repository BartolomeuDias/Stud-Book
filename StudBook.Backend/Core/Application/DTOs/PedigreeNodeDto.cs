using StudBook.Domain;

namespace Application.DTOs;

/// <summary>Краткие данные предка в родословной.</summary>
public record PedigreeNodeDto(
    int Id,
    string Name,
    string Sex,
    string? Breed,
    string? DateOfBirth,
    string? RegistrationNumber)
{
    public static PedigreeNodeDto? From(Horse? h) =>
        h is null
            ? null
            : new(
                h.Id,
                h.Name,
                h.Sex.ToString(),
                h.Breed,
                h.DateOfBirth?.ToString("yyyy-MM-dd"),
                h.RegistrationNumber);
}