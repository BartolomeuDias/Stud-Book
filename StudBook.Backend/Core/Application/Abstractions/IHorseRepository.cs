using StudBook.Domain;

namespace Application.Abstractions;

public interface IHorseRepository
{
    /// <summary>
    /// Активные лошади реестра (без Ancestor). При category == null — все три категории.
    /// </summary>
    Task<IReadOnlyList<Horse>> ListActiveAsync(
        HorseCategory? category = null,
        CancellationToken cancellationToken = default);

    Task<Horse?> GetByIdAsync(int id, CancellationToken cancellationToken = default);
}