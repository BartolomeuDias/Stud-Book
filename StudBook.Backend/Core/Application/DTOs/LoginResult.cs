namespace Application.DTOs
{
    public record LoginResult(string Token, UserDto User);
}