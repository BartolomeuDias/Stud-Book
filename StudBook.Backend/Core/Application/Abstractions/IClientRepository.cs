using StudBook.Domain;

namespace Application.Abstractions;

public interface IClientRepository
{
    Task<IReadOnlyList<Client>> ListAsync(CancellationToken cancellationToken = default);
}