using StudBook.Domain;

namespace Application.DTOs;

public record ClientListItemDto(int Id, string Name, string Type)
{
    public static ClientListItemDto From(Client c) =>
        new(c.Id, c.Name, c.Type.ToString());
}