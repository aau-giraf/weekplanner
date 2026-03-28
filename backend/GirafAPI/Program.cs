using System.Threading.RateLimiting;
using GirafAPI.Configuration;
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

builder.Services.AddExceptionHandler<BadRequestExceptionHandler>();
builder.Services.AddProblemDetails();

builder.Services.AddCors(options =>
{
    options.AddDefaultPolicy(policy =>
    {
        if (builder.Environment.IsDevelopment() || builder.Environment.IsEnvironment("Testing"))
        {
            policy.AllowAnyOrigin()
                .AllowAnyHeader()
                .AllowAnyMethod();
        }
        else
        {
            var origins = builder.Configuration.GetSection("AllowedOrigins").Get<string[]>();
            if (origins is null || origins.Length == 0)
                throw new InvalidOperationException(
                    "AllowedOrigins must be configured in non-development environments.");
            policy.WithOrigins(origins)
                .AllowAnyHeader()
                .AllowAnyMethod();
        }
    });
});

builder.Services.AddRateLimiter(options =>
{
    options.RejectionStatusCode = StatusCodes.Status429TooManyRequests;
    options.GlobalLimiter = PartitionedRateLimiter.Create<HttpContext, string>(context =>
        RateLimitPartition.GetFixedWindowLimiter(
            partitionKey: context.Connection.RemoteIpAddress?.ToString() ?? "unknown",
            factory: _ => new FixedWindowRateLimiterOptions
            {
                PermitLimit = 60,
                Window = TimeSpan.FromMinutes(1),
                QueueLimit = 0,
            }));
});

var app = builder.Build();

// Configure middleware
app.UseExceptionHandler();
app.UseCors();
app.UseRateLimiter();

if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
    app.MapScalarApiReference();
}

app.UseAuthentication();
app.UseAuthorization();

// Map endpoints
app.MapGet("/health", () => Results.Ok()).ExcludeFromDescription();
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
