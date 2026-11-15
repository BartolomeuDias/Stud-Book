using Application.DTOs;

namespace Application.Clients;

public interface IClientService
{
    Task<IReadOnlyList<ClientListItemDto>> ListAsync(CancellationToken cancellationToken = default);
}