using Application.Abstractions;
using Microsoft.EntityFrameworkCore;
using StudBook.Domain;

namespace Infrastructure.Persistence;

public class ClientRepository(StudBookDbContext db) : IClientRepository
{
    public async Task<IReadOnlyList<Client>> ListAsync(CancellationToken cancellationToken = default) =>
        await db.Clients
            .AsNoTracking()
            .OrderBy(c => c.Name)
            .ToListAsync(cancellationToken);
}