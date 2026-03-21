using GirafAPI.Data;
using GirafAPI.Endpoints;
using GirafAPI.Extensions;
using Scalar.AspNetCore;

var builder = WebApplication.CreateBuilder(args);

// Configure services
builder.Services.ConfigureDatabase(builder.Configuration, builder.Environment)
    .ConfigureJwt(builder.Configuration, builder.Environment)
    .ConfigureAuthorization()
    .ConfigureCoreClient(builder.Configuration)
    .ConfigureApplicationServices()
    .ConfigureOpenApi();

builder.Services.AddAntiforgery(options =>
    {
      options.Cookie.Expiration = TimeSpan.Zero;
    });

builder.Services.AddCors(options =>
{
    options.AddDefaultPolicy(policy =>
    {
        if (builder.Environment.IsDevelopment())
        {
            policy.AllowAnyOrigin()
                .AllowAnyHeader()
                .AllowAnyMethod();
        }
        else
        {
            var origins = builder.Configuration.GetSection("AllowedOrigins").Get<string[]>() ?? [];
            policy.WithOrigins(origins)
                .AllowAnyHeader()
                .AllowAnyMethod();
        }
    });
});

var app = builder.Build();

// Configure middleware
app.UseCors();
app.MapOpenApi();
app.MapScalarApiReference();
app.UseAuthentication();
app.UseAuthorization();
app.UseAntiforgery();

// Map endpoints
app.MapActivityEndpoints();

// Apply migrations
if (!app.Environment.IsEnvironment("Testing"))
{
    await app.ApplyMigrationsAsync();
}

if (app.Environment.IsDevelopment())
{
    app.Run("http://0.0.0.0:5171");
}
else
{
    app.Run();
}
