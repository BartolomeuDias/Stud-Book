namespace Application.DTOs;

/// <summary>Родословная на 2 поколения (OW-02.3).</summary>
public record PedigreeDto(
    PedigreeNodeDto? Sire,
    PedigreeNodeDto? Dam,
    PedigreeNodeDto? PaternalGrandsire,
    PedigreeNodeDto? PaternalGranddam,
    PedigreeNodeDto? MaternalGrandsire,
    PedigreeNodeDto? MaternalGranddam);