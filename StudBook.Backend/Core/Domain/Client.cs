using Domain;

namespace StudBook.Domain;
 
public class Client
{
    public int Id { get; set; }
 
    /// <summary>Учётная запись для входа. Null — клиент без доступа в систему.</summary>
    public int? UserId { get; set; }
    public User? User { get; set; }
 
    public string Name { get; set; } = "";
    public ClientType Type { get; set; }
 
    /// <summary>Код штата (TX, OK...). Нужен, чтобы отличать удалённых клиентов.</summary>
    public string StateCode { get; set; } = "";
 
    public string ContactInfo { get; set; } = "";
    public string Notes { get; set; } = "";
 
    /// <summary>Лошади клиента: кобылы, жеребята, жеребец на управлении.</summary>
    public ICollection<Horse> Horses { get; set; } = new List<Horse>();
}