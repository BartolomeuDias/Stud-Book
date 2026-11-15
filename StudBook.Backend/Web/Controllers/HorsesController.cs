using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Application.Services.Horses;
using Microsoft.AspNetCore.Mvc;
using StudBook.Domain;

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
    }
}