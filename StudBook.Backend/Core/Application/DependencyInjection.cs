using Application.Auth;
using Application.Services.Horses;
using Microsoft.Extensions.DependencyInjection;

namespace Application;
public static class DependencyInjection
{
    public static IServiceCollection AddApplication(this IServiceCollection services)
    {
        services.AddScoped<IAuthService, AuthService>();
        services.AddScoped<IHorseService, HorseService>();
        return services;
    }
}