using Application.Abstractions;
using Application.DTOs;
using StudBook.Domain;

namespace Application.Services.Horses
{
    public class HorseService(IHorseRepository horses) : IHorseService
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
    }
}