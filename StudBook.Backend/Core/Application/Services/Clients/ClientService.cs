using Application.Abstractions;
using Application.DTOs;

namespace Application.Clients;

public class ClientService(IClientRepository clients) : IClientService
{
    public async Task<IReadOnlyList<ClientListItemDto>> ListAsync(
        CancellationToken cancellationToken = default)
    {
        var list = await clients.ListAsync(cancellationToken);
        return list.Select(ClientListItemDto.From).ToList();
    }
}