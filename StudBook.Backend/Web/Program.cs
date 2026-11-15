using Application;
using Infrastructure;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddOpenApi();

var connectionString = builder.Configuration.GetConnectionString("Default")
    ?? "Host=127.0.0.1;Port=5433;Database=studbook;Username=studbook;Password=studbook";

builder.Services.AddControllers();
builder.Services.AddOpenApi();
builder.Services.AddApplication();
builder.Services.AddInfrastructure(connectionString);

const string LocalFrontendPolicy = "LocalFrontend";
builder.Services.AddCors(options => options.AddPolicy(LocalFrontendPolicy, policy => policy
    .SetIsOriginAllowed(origin => Uri.TryCreate(origin, UriKind.Absolute, out var uri) && uri.IsLoopback)
    .AllowAnyHeader()
    .AllowAnyMethod()));

var app = builder.Build();

await app.Services.InitializeDatabaseAsync();

if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
    app.UseCors(LocalFrontendPolicy);
}

app.UseHttpsRedirection();
app.MapControllers();

app.Run();