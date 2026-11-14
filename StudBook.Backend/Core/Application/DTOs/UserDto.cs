using StudBook.Domain;

namespace Application.DTOs
{
    public record UserDto(int Id, string Email, string DisplayName, string Role)
    {
        public static UserDto From(User user) =>
            new(user.Id, user.Email, user.DisplayName, user.Role.ToString());
    }
}