using Application.Abstractions;
using Application.DTOs;
using StudBook.Domain;

namespace Application.Services.Horses
{
    public class HorseService(IHorseRepository horses, IClientRepository clients) : IHorseService
    {
        public async Task<IReadOnlyList<HorseListItemDto>> ListRegistryAsync(
            HorseCategory? category = null,
            CancellationToken cancellationToken = default)
        {
            var list = await horses.ListActiveAsync(category, cancellationToken);
            return list.Select(HorseListItemDto.From).ToList();
        }

        public async Task<HorseCardDto?> GetCardAsync(
        int id,
        CancellationToken cancellationToken = default)
        {
            var horse = await horses.GetByIdAsync(id, cancellationToken);
            return horse is null ? null : HorseCardDto.From(horse);
        }

        public async Task<HorseCardDto> CreateAsync(
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
            CancellationToken cancellationToken = default)
        {
            name = (name ?? "").Trim();
            breed = (breed ?? "").Trim();
            color = (color ?? "").Trim();
            registrationNumber = string.IsNullOrWhiteSpace(registrationNumber)
                ? null
                : registrationNumber.Trim();
            notes = (notes ?? "").Trim();

            if (string.IsNullOrEmpty(name))
                throw new ArgumentException("Укажите кличку.");
            if (string.IsNullOrEmpty(breed))
                throw new ArgumentException("Укажите породу.");
            if (string.IsNullOrEmpty(color))
                throw new ArgumentException("Укажите масть.");

            if (category == HorseCategory.Ancestor)
                throw new ArgumentException("В реестр нельзя добавить запись категории Ancestor.");

            if (category == HorseCategory.OwnStallion && ownerClientId.HasValue)
                throw new ArgumentException("У собственного жеребца ранчо не должно быть владельца-клиента.");

            if (category is HorseCategory.ManagedStallion or HorseCategory.ClientHorse
                && !ownerClientId.HasValue)
                throw new ArgumentException("Для этой категории укажите владельца-клиента.");

            if (ownerClientId.HasValue)
            {
                var allClients = await clients.ListAsync(cancellationToken);
                if (allClients.All(c => c.Id != ownerClientId.Value))
                    throw new ArgumentException($"Клиент id={ownerClientId} не найден.");
            }

            if (sireId.HasValue)
            {
                var sire = await horses.GetByIdAsync(sireId.Value, cancellationToken)
                    ?? throw new ArgumentException($"Отец id={sireId} не найден.");
                if (sire.Sex != HorseSex.Stallion)
                    throw new ArgumentException("Отец должен быть жеребцом (Stallion).");
            }

            if (damId.HasValue)
            {
                var dam = await horses.GetByIdAsync(damId.Value, cancellationToken)
                    ?? throw new ArgumentException($"Мать id={damId} не найдена.");
                if (dam.Sex != HorseSex.Mare)
                    throw new ArgumentException("Мать должна быть кобылой (Mare).");
            }

            if (sireId.HasValue && damId.HasValue && sireId == damId)
                throw new ArgumentException("Отец и мать не могут быть одной и той же записью.");

            var horse = new Horse
            {
                Name = name,
                Category = category,
                Sex = sex,
                Breed = breed,
                Color = color,
                DateOfBirth = dateOfBirth,
                RegistrationNumber = registrationNumber,
                OwnerClientId = ownerClientId,
                SireId = sireId,
                DamId = damId,
                Notes = notes,
                IsActive = true,
                CreatedAt = DateTime.UtcNow
            };

            var created = await horses.AddAsync(horse, cancellationToken);

            // Перечитываем с навигацией для карточки
            var full = await horses.GetByIdAsync(created.Id, cancellationToken)
                ?? created;
            return HorseCardDto.From(full);
        }
    }
}