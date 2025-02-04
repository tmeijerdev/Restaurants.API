using Restaurants.Infrastructure.Extensions;
using Restaurants.Infrastructure.Seeders;
using Restaurants.Application.Extensions;
using Serilog;
using Restaurants.API.Middlewares;
using Restaurants.Domain.Entities;
using Restaurants.API.Extensions;
using Restaurants.Infrastructure.Persistence;
using Microsoft.EntityFrameworkCore;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.AddPresentation();
builder.Services.AddApplication();
builder.Services.AddInfrastructure(builder.Configuration);



// builder.Host.UseSerilog((context, configuration) => 
// {
//     //Rolling interface says when to use a new file
//     configuration
//         .MinimumLevel.Override("Microsoft", LogEventLevel.Warning)
//         .MinimumLevel.Override("Microsoft.EntityFrameworkCore", LogEventLevel.Information)
//         .WriteTo.File("Logs/Restaurant-API-.log", rollingInterval: RollingInterval.Day, rollOnFileSizeLimit: true)
//         .WriteTo.Console(outputTemplate: "[{Timestamp:dd-MM HH:mm:ss} {Level:u3}] |{SourceContext}| {NewLine}{Message:lj}{NewLine}{Exception}");
// });

var app = builder.Build();

var scope = app.Services.CreateScope();
var services = scope.ServiceProvider;
var context = services.GetRequiredService<RestaurantsDbContext>();
var seeder = services.GetRequiredService<IRestaurantSeeder>();

try
{
    await context.Database.EnsureCreatedAsync(); 
    await seeder.Seed(); 
    await context.Database.MigrateAsync(); 
}
catch (Exception ex)
{
    var logger = services.GetRequiredService<ILogger<Program>>();
    logger.LogError(ex, "Error with performing migrations or seeding");
}

// Configure the HTTP request pipeline.
// First one for global exception handling
app.UseMiddleware<ErrorHandlingMiddleware>();
app.UseMiddleware<RequestTimeLoggingMiddleware>();

// Enable this to add HTTP context logging
app.UseSerilogRequestLogging();

if(app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}
app.UseSwagger();
app.UseSwaggerUI();

app.UseHttpsRedirection();

// Add prefix api/identity 
app.MapGroup("api/identity")
    .WithTags("Identity")
    .MapIdentityApi<User>();

// app.MapIdentityApi<User>();

app.UseAuthorization();

app.MapControllers();

app.Run();
