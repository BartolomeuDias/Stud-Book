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
    }
}