using Application.Clients;
using Microsoft.AspNetCore.Mvc;

namespace Web.Controllers;

[ApiController]
[Route("api/clients")]
public class ClientsController(IClientService clients) : ControllerBase
{
    /// <summary>Список клиентов (для выбора владельца при OW-03).</summary>
    [HttpGet]
    public async Task<IActionResult> List(CancellationToken cancellationToken = default)
    {
        var items = await clients.ListAsync(cancellationToken);
        return Ok(items);
    }
}