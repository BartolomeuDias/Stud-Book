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

        /// <summary>Добавить лошадь в реестр (OW-03). При ошибке валидации — ArgumentException.</summary>
        Task<HorseCardDto> CreateAsync(
            string name,
            HorseCategory category,
            HorseSex sex,
            string breed,
            string color,
            DateOnly? dateOfBirth,
            string? registrationNumber,
            int? ownerClientId,
            int? sireId,
            int? damId,
            string notes,
            CancellationToken cancellationToken = default);

        Task<HorseCardDto?> UpdateAsync(
            int id,
            string name,
            HorseCategory category,
            HorseSex sex,
            string breed,
            string color,
            DateOnly? dateOfBirth,
            string? registrationNumber,
            int? ownerClientId,
            int? sireId,
            int? damId,
            string notes,
            CancellationToken cancellationToken = default);

        /// <summary>
        /// Убрать из реестра (IsActive = false). Запись для родословной сохраняется.
        /// </summary>
        Task<bool> DeactivateAsync(int id, CancellationToken cancellationToken = default);
    }
}