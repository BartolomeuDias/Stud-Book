using Application.Services.Horses;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using StudBook.Domain;
using Web.Contracts;

namespace Web.Controllers
{
    [ApiController]
    [Route("api/horses")]
    public class HorsesController(IHorseService horses) : ControllerBase
    {
        /// <summary>
        /// Реестр лошадей трёх категорий (OW-01).
        /// Без параметра — все активные (OwnStallion, ManagedStallion, ClientHorse).
        /// category=OwnStallion|ManagedStallion|ClientHorse — фильтр.
        /// </summary>
        [HttpGet]
        public async Task<IActionResult> List(
            [FromQuery] string? category = null,
            CancellationToken cancellationToken = default)
        {
            HorseCategory? cat = null;
            if (!string.IsNullOrWhiteSpace(category))
            {
                if (!Enum.TryParse<HorseCategory>(category, ignoreCase: true, out var parsed)
                    || parsed == HorseCategory.Ancestor)
                {
                    return BadRequest(new
                    {
                        error = "Invalid category. Use OwnStallion, ManagedStallion or ClientHorse."
                    });
                }
                cat = parsed;
            }

            var items = await horses.ListRegistryAsync(cat, cancellationToken);
            return Ok(items);
        }

        /// <summary>
        /// Карточка лошади с родословной на 2 поколения (OW-02.2, OW-02.3).
        /// </summary>
        [HttpGet("{id:int}")]
        public async Task<IActionResult> GetCard(int id, CancellationToken cancellationToken = default)
        {
            var card = await horses.GetCardAsync(id, cancellationToken);
            return card is null ? NotFound() : Ok(card);
        }

        /// <summary>Добавить лошадь в реестр (OW-03).</summary>
        [HttpPost]
        public async Task<IActionResult> Create(
            [FromBody] CreateHorseRequest request,
            CancellationToken cancellationToken = default)
        {
            if (!Enum.TryParse<HorseCategory>(request.Category, ignoreCase: true, out var category)
                || category == HorseCategory.Ancestor)
            {
                return BadRequest(new { error = "Category: OwnStallion, ManagedStallion или ClientHorse." });
            }

            if (!Enum.TryParse<HorseSex>(request.Sex, ignoreCase: true, out var sex))
            {
                return BadRequest(new { error = "Sex: Stallion, Mare или Gelding." });
            }

            DateOnly? dob = null;
            if (!string.IsNullOrWhiteSpace(request.DateOfBirth))
            {
                if (!DateOnly.TryParse(request.DateOfBirth, out var parsedDob))
                    return BadRequest(new { error = "DateOfBirth: ожидается yyyy-MM-dd." });
                dob = parsedDob;
            }

            try
            {
                var card = await horses.CreateAsync(
                    request.Name,
                    category,
                    sex,
                    request.Breed,
                    request.Color,
                    dob,
                    request.RegistrationNumber,
                    request.OwnerClientId,
                    request.SireId,
                    request.DamId,
                    request.Notes,
                    cancellationToken);

                return CreatedAtAction(nameof(GetCard), new { id = card.Id }, card);
            }
            catch (ArgumentException ex)
            {
                return BadRequest(new { error = ex.Message });
            }
            catch (DbUpdateException)
            {
                // уникальный RegistrationNumber и т.п.
                return BadRequest(new { error = "Не удалось сохранить: возможно, такой рег. номер уже есть." });
            }
        }

        /// <summary>Обновить лошадь (редактирование в реестре).</summary>
        [HttpPut("{id:int}")]
        public async Task<IActionResult> Update(
            int id,
            [FromBody] UpdateHorseRequest request,
            CancellationToken cancellationToken = default)
        {
            if (!Enum.TryParse<HorseCategory>(request.Category, ignoreCase: true, out var category)
                || category == HorseCategory.Ancestor)
            {
                return BadRequest(new { error = "Category: OwnStallion, ManagedStallion или ClientHorse." });
            }

            if (!Enum.TryParse<HorseSex>(request.Sex, ignoreCase: true, out var sex))
            {
                return BadRequest(new { error = "Sex: Stallion, Mare или Gelding." });
            }

            DateOnly? dob = null;
            if (!string.IsNullOrWhiteSpace(request.DateOfBirth))
            {
                if (!DateOnly.TryParse(request.DateOfBirth, out var parsedDob))
                    return BadRequest(new { error = "DateOfBirth: ожидается yyyy-MM-dd." });
                dob = parsedDob;
            }

            try
            {
                var card = await horses.UpdateAsync(
                    id,
                    request.Name,
                    category,
                    sex,
                    request.Breed,
                    request.Color,
                    dob,
                    request.RegistrationNumber,
                    request.OwnerClientId,
                    request.SireId,
                    request.DamId,
                    request.Notes,
                    cancellationToken);

                return card is null ? NotFound() : Ok(card);
            }
            catch (ArgumentException ex)
            {
                return BadRequest(new { error = ex.Message });
            }
            catch (DbUpdateException)
            {
                return BadRequest(new { error = "Не удалось сохранить: возможно, такой рег. номер уже есть." });
            }
        }

        /// <summary>
        /// Убрать лошадь из реестра (мягкое удаление: IsActive = false).
        /// Запись остаётся в БД для родословных.
        /// </summary>
        [HttpDelete("{id:int}")]
        public async Task<IActionResult> Deactivate(int id, CancellationToken cancellationToken = default)
        {
            var ok = await horses.DeactivateAsync(id, cancellationToken);
            return ok ? NoContent() : NotFound();
        }
    }
}