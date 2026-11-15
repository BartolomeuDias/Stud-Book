using Application.Auth;
using Application.Clients;
using Application.Services.Horses;
using Microsoft.Extensions.DependencyInjection;

namespace Application;
public static class DependencyInjection
{
    public static IServiceCollection AddApplication(this IServiceCollection services)
    {
        services.AddScoped<IAuthService, AuthService>();
        services.AddScoped<IHorseService, HorseService>();
        services.AddScoped<IClientService, ClientService>();
        return services;
    }
}