using Application.DTOs;
using StudBook.Domain;

namespace Application.Services.Horses
{
    public interface IHorseService
    {
        Task<IReadOnlyList<HorseListItemDto>> ListRegistryAsync(
            HorseCategory? category = null,
            CancellationToken cancellationToken = default);
    }
}