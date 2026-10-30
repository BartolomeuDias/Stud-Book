using Microsoft.EntityFrameworkCore;
using StudBook.Api.Data;
using StudBook.Api.Endpoints;
using StudBook.Api.Models;
using StudBook.Api.Pages;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseNpgsql(builder.Configuration.GetConnectionString("Default")
        ?? "Host=127.0.0.1;Port=5432;Database=studbook;Username=studbook;Password=studbook;SSL Mode=Disable"));

builder.Services.AddOpenApi();
builder.Services.AddEndpointsApiExplorer();

var app = builder.Build();

using (var scope = app.Services.CreateScope())
{
    var db = scope.ServiceProvider.GetRequiredService<AppDbContext>();
    db.Database.EnsureCreated();

    if (!db.Users.Any())
    {
        db.Users.AddRange(
            new User { Email = "client@test.com", Role = "Client", DisplayName = "Test Client" },
            new User { Email = "staff@test.com", Role = "RanchStaff", DisplayName = "Dusty (Owner)" }
        );
        db.SaveChanges();
    }
}

if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
}

app.UseHttpsRedirection();

// Endpoints
app.MapHealthEndpoints();
app.MapAuthEndpoints();

// Pages
app.MapGet("/", () => Results.Content(HomePage.Html, "text/html"));
app.MapGet("/login", () => Results.Content(LoginPage.Html, "text/html"));
app.MapGet("/client", () => Results.Content(ClientPage.Html, "text/html"));
app.MapGet("/staff", () => Results.Content(StaffPage.Html, "text/html"));

app.Run();