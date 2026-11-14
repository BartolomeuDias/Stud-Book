namespace StudBook.Domain;

public class User
{
    public int Id { get; set; }
    public string Email { get; set; } = "";
    public string DisplayName { get; set; } = "";
    public UserRole Role { get; set; }
 
    /// <summary>Профиль клиента, если пользователь входит как клиент.</summary>
    public Client? Client { get; set; }
}
