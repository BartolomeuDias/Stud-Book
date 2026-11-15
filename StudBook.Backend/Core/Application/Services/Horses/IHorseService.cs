using Application.DTOs;
using StudBook.Domain;

namespace Application.Services.Horses
{
    public interface IHorseService
    {
        Task<IReadOnlyList<HorseListItemDto>> ListRegistryAsync(
            HorseCategory? category = null,
            CancellationToken cancellationToken = default);

        /// <summary>
        /// Карточка лошади с родословной на 2 поколения (OW-02.2, OW-02.3).
        /// </summary>
        Task<HorseCardDto?> GetCardAsync(int id, CancellationToken cancellationToken = default);
    }
}