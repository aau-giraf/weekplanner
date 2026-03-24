using GirafAPI.Entities.Activities;
using GirafAPI.Entities.Activities.DTOs;
using GirafAPI.Services;

namespace GirafAPI.Endpoints;

public static class ActivityEndpoints
{
    private static string? GetAccessToken(HttpContext context)
    {
        var auth = context.Request.Headers.Authorization.ToString();
        if (auth.StartsWith("Bearer ", StringComparison.OrdinalIgnoreCase))
            return auth["Bearer ".Length..].Trim();
        return null;
    }

    public static RouteGroupBuilder MapActivityEndpoints(this WebApplication app)
    {
        var group = app.MapGroup("weekplan");

        // GET activities for one day for a citizen
        group.MapGet("/{citizenId:int}", async Task<IResult> (int citizenId, DateOnly date,
                IActivityService service, HttpContext httpContext, CancellationToken ct) =>
            {
                var token = GetAccessToken(httpContext);
                if (token is null)
                    return TypedResults.Unauthorized();

                var result = await service.GetActivitiesByOwnerAsync(
                    new ActivityOwner.Citizen(citizenId), date, token, ct);
                return result.ToHttpResult(v => TypedResults.Ok(v));
            })
            .WithName("GetActivitiesForCitizenOnDate")
            .WithDescription("Gets activities for a specific citizen on a given date.")
            .WithTags("Activities")
            .RequireAuthorization()
            .Produces<List<ActivityDTO>>(StatusCodes.Status200OK)
            .Produces(StatusCodes.Status401Unauthorized)
            .Produces(StatusCodes.Status500InternalServerError);

        // GET activities for one day for a grade
        group.MapGet("/grade/{gradeId:int}", async Task<IResult> (int gradeId, DateOnly date,
                IActivityService service, HttpContext httpContext, CancellationToken ct) =>
            {
                var token = GetAccessToken(httpContext);
                if (token is null)
                    return TypedResults.Unauthorized();

                var result = await service.GetActivitiesByOwnerAsync(
                    new ActivityOwner.Grade(gradeId), date, token, ct);
                return result.ToHttpResult(v => TypedResults.Ok(v));
            })
            .WithName("GetActivitiesForGradeOnDate")
            .WithDescription("Gets activities for a specific grade on a given date.")
            .WithTags("Activities")
            .RequireAuthorization()
            .Produces<List<ActivityDTO>>(StatusCodes.Status200OK)
            .Produces(StatusCodes.Status401Unauthorized)
            .Produces(StatusCodes.Status404NotFound)
            .Produces(StatusCodes.Status500InternalServerError);


        // GET single activity by ID
        group.MapGet("/activity/{id:int}", async Task<IResult> (int id, IActivityService service,
                HttpContext httpContext, CancellationToken ct) =>
            {
                var token = GetAccessToken(httpContext);
                if (token is null)
                    return TypedResults.Unauthorized();

                var result = await service.GetActivityByIdAsync(id, token, ct);
                return result.ToHttpResult(v => TypedResults.Ok(v));
            })
            .WithName("GetActivityById")
            .WithDescription("Gets a specific activity by ID.")
            .WithTags("Activities")
            .RequireAuthorization()
            .Produces<ActivityDTO>(StatusCodes.Status200OK)
            .Produces(StatusCodes.Status401Unauthorized)
            .Produces(StatusCodes.Status404NotFound)
            .Produces(StatusCodes.Status500InternalServerError);


        // POST new activity for citizen
        group.MapPost("/to-citizen/{citizenId:int}",
                async Task<IResult> (int citizenId, CreateActivityDTO dto, IActivityService service,
                    HttpContext httpContext, CancellationToken ct) =>
                {
                    var token = GetAccessToken(httpContext);
                    if (token is null)
                        return TypedResults.Unauthorized();

                    var result = await service.CreateActivityAsync(
                        new ActivityOwner.Citizen(citizenId), dto, token, ct);
                    return result.ToHttpResult(v => TypedResults.Created($"/activity/{v.ActivityId}", v));
                })
            .WithName("CreateActivityForCitizen")
            .WithDescription("Creates a new activity for a citizen.")
            .WithTags("Activities")
            .RequireAuthorization()
            .Accepts<CreateActivityDTO>("application/json")
            .Produces<ActivityDTO>(StatusCodes.Status201Created)
            .Produces(StatusCodes.Status401Unauthorized)
            .Produces(StatusCodes.Status404NotFound)
            .Produces(StatusCodes.Status500InternalServerError);

        // POST new activity for grade
        group.MapPost("/to-grade/{gradeId:int}",
                async Task<IResult> (int gradeId, CreateActivityDTO dto, IActivityService service,
                    HttpContext httpContext, CancellationToken ct) =>
                {
                    var token = GetAccessToken(httpContext);
                    if (token is null)
                        return TypedResults.Unauthorized();

                    var result = await service.CreateActivityAsync(
                        new ActivityOwner.Grade(gradeId), dto, token, ct);
                    return result.ToHttpResult(v => TypedResults.Created($"/activity/{v.ActivityId}", v));
                })
            .WithName("CreateActivityForGrade")
            .WithDescription("Creates a new activity for a grade.")
            .WithTags("Activities")
            .RequireAuthorization()
            .Accepts<CreateActivityDTO>("application/json")
            .Produces<ActivityDTO>(StatusCodes.Status201Created)
            .Produces(StatusCodes.Status401Unauthorized)
            .Produces(StatusCodes.Status404NotFound)
            .Produces(StatusCodes.Status500InternalServerError);


        group.MapPost("/activity/copy-citizen/{citizenId:int}",
                async Task<IResult> (int citizenId, DateOnly sourceDate, DateOnly targetDate, List<int> toCopyIds,
                    IActivityService service, HttpContext httpContext, CancellationToken ct) =>
                {
                    var token = GetAccessToken(httpContext);
                    if (token is null)
                        return TypedResults.Unauthorized();

                    var result = await service.CopyActivitiesAsync(
                        new ActivityOwner.Citizen(citizenId), sourceDate, targetDate, toCopyIds, token, ct);
                    return result.ToHttpResult(() => TypedResults.Ok("Activities successfully copied."));
                })
            .WithName("CopyActivityForCitizen")
            .WithDescription("Copies activities between days for a citizen")
            .WithTags("Activities")
            .RequireAuthorization()
            .Produces(StatusCodes.Status401Unauthorized)
            .Produces(StatusCodes.Status400BadRequest)
            .Produces(StatusCodes.Status200OK);

        group.MapPost("/activity/copy-grade/{gradeId:int}",
                async Task<IResult> (int gradeId, DateOnly sourceDate, DateOnly targetDate, List<int> toCopyIds,
                    IActivityService service, HttpContext httpContext, CancellationToken ct) =>
                {
                    var token = GetAccessToken(httpContext);
                    if (token is null)
                        return TypedResults.Unauthorized();

                    var result = await service.CopyActivitiesAsync(
                        new ActivityOwner.Grade(gradeId), sourceDate, targetDate, toCopyIds, token, ct);
                    return result.ToHttpResult(() => TypedResults.Ok("Activities successfully copied."));
                })
            .WithName("CopyActivityForGrade")
            .WithDescription("Copies activities between days for a grade")
            .WithTags("Activities")
            .RequireAuthorization()
            .Produces(StatusCodes.Status401Unauthorized)
            .Produces(StatusCodes.Status400BadRequest)
            .Produces(StatusCodes.Status200OK);

        // PUT updated activity
        group.MapPut("/activity/{id:int}",
                async Task<IResult> (int id, UpdateActivityDTO dto, IActivityService service,
                    HttpContext httpContext, CancellationToken ct) =>
                {
                    var token = GetAccessToken(httpContext);
                    if (token is null)
                        return TypedResults.Unauthorized();

                    var result = await service.UpdateActivityAsync(id, dto, token, ct);
                    return result.ToHttpResult(() => TypedResults.Ok());
                })
            .WithName("UpdateActivity")
            .WithDescription("Updates an existing activity using ID.")
            .WithTags("Activities")
            .RequireAuthorization()
            .Accepts<UpdateActivityDTO>("application/json")
            .Produces(StatusCodes.Status200OK)
            .Produces(StatusCodes.Status401Unauthorized)
            .Produces(StatusCodes.Status404NotFound)
            .Produces(StatusCodes.Status400BadRequest)
            .Produces(StatusCodes.Status500InternalServerError);


        // PUT IsComplete activity
        group.MapPut("/activity/{id:int}/iscomplete",
                async Task<IResult> (int id, bool IsComplete, IActivityService service,
                    HttpContext httpContext, CancellationToken ct) =>
                {
                    var token = GetAccessToken(httpContext);
                    if (token is null)
                        return TypedResults.Unauthorized();

                    var result = await service.ToggleActivityStatusAsync(id, IsComplete, token, ct);
                    return result.ToHttpResult(() => TypedResults.Ok());
                })
            .WithName("CompleteActivity")
            .WithDescription("Completes an existing activity using ID.")
            .WithTags("Activities")
            .RequireAuthorization()
            .Produces(StatusCodes.Status200OK)
            .Produces(StatusCodes.Status401Unauthorized)
            .Produces(StatusCodes.Status400BadRequest)
            .Produces(StatusCodes.Status500InternalServerError);


        // DELETE activity
        group.MapDelete("/activity/{id:int}", async Task<IResult> (int id, IActivityService service,
                HttpContext httpContext, CancellationToken ct) =>
            {
                var token = GetAccessToken(httpContext);
                if (token is null)
                    return TypedResults.Unauthorized();

                var result = await service.DeleteActivityAsync(id, token, ct);
                return result.ToHttpResult(() => TypedResults.NoContent());
            })
            .WithName("DeleteActivity")
            .WithDescription("Deletes an activity by ID.")
            .WithTags("Activities")
            .RequireAuthorization()
            .Produces(StatusCodes.Status204NoContent)
            .Produces(StatusCodes.Status401Unauthorized)
            .Produces(StatusCodes.Status404NotFound)
            .Produces(StatusCodes.Status400BadRequest)
            .Produces(StatusCodes.Status500InternalServerError);

        group.MapPost("/activity/assign-pictogram/{activityId:int}/{pictogramId:int}",
                async Task<IResult> (int activityId, int pictogramId, IActivityService service,
                    HttpContext httpContext, CancellationToken ct) =>
                {
                    var token = GetAccessToken(httpContext);
                    if (token is null)
                        return TypedResults.Unauthorized();

                    var result = await service.AssignPictogramAsync(activityId, pictogramId, token, ct);
                    return result.ToHttpResult(v => TypedResults.Ok(v));
                })
            .WithName("AssignPictogram")
            .WithDescription("Assigns a pictogram by ID.")
            .WithTags("Activities")
            .RequireAuthorization()
            .Produces(StatusCodes.Status200OK)
            .Produces(StatusCodes.Status401Unauthorized)
            .Produces(StatusCodes.Status404NotFound)
            .Produces(StatusCodes.Status500InternalServerError);


        return group;
    }
}
