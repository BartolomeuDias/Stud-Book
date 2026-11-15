using Application.Services.CompatibilityRules;
using Microsoft.AspNetCore.Mvc;
using Web.Contracts;

namespace Web.Controllers;

[ApiController]
[Route("api/compatibility-rules")]
public class CompatibilityRulesController(ICompatibilityRuleService rules) : ControllerBase
{
    /// <summary>Единая таблица правил допустимости пар (OW-15).</summary>
    [HttpGet]
    public async Task<IActionResult> List(CancellationToken cancellationToken = default)
    {
        var items = await rules.ListAsync(cancellationToken);
        return Ok(items);
    }

    /// <summary>Обновить активность / приоритет / порог / источник согласования.</summary>
    [HttpPatch("{id:int}")]
    public async Task<IActionResult> Update(
        int id,
        [FromBody] UpdateCompatibilityRuleRequest request,
        CancellationToken cancellationToken = default)
    {
        try
        {
            var item = await rules.UpdateAsync(
                id,
                request.IsActive,
                request.Priority,
                request.Threshold,
                request.ThresholdUnit,
                request.Source,
                cancellationToken);

            return item is null ? NotFound() : Ok(item);
        }
        catch (ArgumentException ex)
        {
            return BadRequest(new { error = ex.Message });
        }
    }
}