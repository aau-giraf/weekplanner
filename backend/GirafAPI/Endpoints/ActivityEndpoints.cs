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

    private static IResult ToHttpResult(ServiceResult result) =>
        result.IsSuccess
            ? Results.Ok()
            : result.Error!.Kind switch
            {
                ServiceErrorKind.NotFound => Results.NotFound(result.Error.Message),
                ServiceErrorKind.Validation => Results.BadRequest(result.Error.Message),
                ServiceErrorKind.Unauthorized => Results.Unauthorized(),
                _ => Results.Problem(result.Error.Message,
                    statusCode: StatusCodes.Status500InternalServerError)
            };

    private static IResult ToHttpResult<T>(ServiceResult<T> result, Func<T, IResult>? onSuccess = null) =>
        result.IsSuccess
            ? (onSuccess ?? (v => Results.Ok(v)))(result.Value!)
            : result.Error!.Kind switch
            {
                ServiceErrorKind.NotFound => Results.NotFound(result.Error.Message),
                ServiceErrorKind.Validation => Results.BadRequest(result.Error.Message),
                ServiceErrorKind.Unauthorized => Results.Unauthorized(),
                _ => Results.Problem(result.Error.Message,
                    statusCode: StatusCodes.Status500InternalServerError)
            };

    public static RouteGroupBuilder MapActivityEndpoints(this WebApplication app)
    {
        var group = app.MapGroup("weekplan");

        // GET all activities (mainly for debugging)
        group.MapGet("/", async (IActivityService service) =>
            {
                var result = await service.GetAllActivitiesAsync();
                return ToHttpResult(result);
            })
            .WithName("GetAllActivities")
            .WithDescription("Gets all activities.")
            .WithTags("Activities")
            .RequireAuthorization()
            .Produces<List<ActivityDTO>>(StatusCodes.Status200OK)
            .Produces(StatusCodes.Status500InternalServerError);


        // GET activities for one day for a citizen
        group.MapGet("/{citizenId:int}", async (int citizenId, string date, IActivityService service) =>
            {
                var result = await service.GetActivitiesByCitizenAsync(citizenId, date);
                return ToHttpResult(result);
            })
            .WithName("GetActivitiesForCitizenOnDate")
            .WithDescription("Gets activities for a specific citizen on a given date.")
            .WithTags("Activities")
            .RequireAuthorization()
            .Produces<List<ActivityDTO>>(StatusCodes.Status200OK)
            .Produces(StatusCodes.Status500InternalServerError);

        // GET activities for one day for a grade
        group.MapGet("/grade/{gradeId:int}", async (int gradeId, string date, IActivityService service) =>
            {
                var result = await service.GetActivitiesByGradeAsync(gradeId, date);
                return ToHttpResult(result);
            })
            .WithName("GetActivitiesForGradeOnDate")
            .WithDescription("Gets activities for a specific grade on a given date.")
            .WithTags("Activities")
            .RequireAuthorization()
            .Produces<List<ActivityDTO>>(StatusCodes.Status200OK)
            .Produces(StatusCodes.Status404NotFound)
            .Produces(StatusCodes.Status500InternalServerError);


        // GET single activity by ID
        group.MapGet("/activity/{id:int}", async (int id, IActivityService service) =>
            {
                var result = await service.GetActivityByIdAsync(id);
                return ToHttpResult(result);
            })
            .WithName("GetActivityById")
            .WithDescription("Gets a specific activity by ID.")
            .WithTags("Activities")
            .RequireAuthorization()
            .Produces<ActivityDTO>(StatusCodes.Status200OK)
            .Produces(StatusCodes.Status404NotFound)
            .Produces(StatusCodes.Status500InternalServerError);


        // POST new activity for citizen
        group.MapPost("/to-citizen/{citizenId:int}",
                async (int citizenId, CreateActivityDTO dto, IActivityService service,
                    HttpContext httpContext) =>
                {
                    var token = GetAccessToken(httpContext);
                    if (token is null)
                        return Results.Unauthorized();

                    var result = await service.CreateActivityForCitizenAsync(citizenId, dto, token);
                    return ToHttpResult(result,
                        v => Results.Created($"/activity/{v.ActivityId}", v));
                })
            .WithName("CreateActivityForCitizen")
            .WithDescription("Creates a new activity for a citizen.")
            .WithTags("Activities")
            .RequireAuthorization()
            .Accepts<CreateActivityDTO>("application/json")
            .Produces<ActivityDTO>(StatusCodes.Status201Created)
            .Produces(StatusCodes.Status404NotFound)
            .Produces(StatusCodes.Status500InternalServerError);

        // POST new activity for grade
        group.MapPost("/to-grade/{gradeId:int}",
                async (int gradeId, CreateActivityDTO dto, IActivityService service,
                    HttpContext httpContext) =>
                {
                    var token = GetAccessToken(httpContext);
                    if (token is null)
                        return Results.Unauthorized();

                    var result = await service.CreateActivityForGradeAsync(gradeId, dto, token);
                    return ToHttpResult(result,
                        v => Results.Created($"/activity/{v.ActivityId}", v));
                })
            .WithName("CreateActivityForGrade")
            .WithDescription("Creates a new activity for a grade.")
            .WithTags("Activities")
            .RequireAuthorization()
            .Accepts<CreateActivityDTO>("application/json")
            .Produces<ActivityDTO>(StatusCodes.Status201Created)
            .Produces(StatusCodes.Status404NotFound)
            .Produces(StatusCodes.Status500InternalServerError);


        group.MapPost("/activity/copy-citizen/{citizenId:int}",
                async (int citizenId, string dateStr, string newDateStr, List<int> toCopyIds,
                    IActivityService service) =>
                {
                    var result = await service.CopyActivitiesForCitizenAsync(
                        citizenId, dateStr, newDateStr, toCopyIds);
                    return result.IsSuccess
                        ? Results.Ok("Activities successfully copied.")
                        : ToHttpResult(result);
                })
            .WithName("CopyActivityForCitizen")
            .WithDescription("Copies activities between days for a citizen")
            .WithTags("Activities")
            .RequireAuthorization()
            .Produces(StatusCodes.Status400BadRequest)
            .Produces(StatusCodes.Status200OK);

        group.MapPost("/activity/copy-grade/{gradeId:int}",
                async (int gradeId, string dateStr, string newDateStr, List<int> toCopyIds,
                    IActivityService service) =>
                {
                    var result = await service.CopyActivitiesForGradeAsync(
                        gradeId, dateStr, newDateStr, toCopyIds);
                    return result.IsSuccess
                        ? Results.Ok("Activities successfully copied.")
                        : ToHttpResult(result);
                })
            .WithName("CopyActivityForGrade")
            .WithDescription("Copies activities between days for a grade")
            .WithTags("Activities")
            .RequireAuthorization()
            .Produces(StatusCodes.Status400BadRequest)
            .Produces(StatusCodes.Status200OK);

        // PUT updated activity
        group.MapPut("/activity/{id:int}",
                async (int id, UpdateActivityDTO dto, IActivityService service,
                    HttpContext httpContext) =>
                {
                    var token = GetAccessToken(httpContext);
                    if (token is null)
                        return Results.Unauthorized();

                    var result = await service.UpdateActivityAsync(id, dto, token);
                    return ToHttpResult(result);
                })
            .WithName("UpdateActivity")
            .WithDescription("Updates an existing activity using ID.")
            .WithTags("Activities")
            .RequireAuthorization()
            .Accepts<UpdateActivityDTO>("application/json")
            .Produces(StatusCodes.Status200OK)
            .Produces(StatusCodes.Status404NotFound)
            .Produces(StatusCodes.Status400BadRequest)
            .Produces(StatusCodes.Status500InternalServerError);


        // PUT IsComplete activity
        group.MapPut("/activity/{id:int}/iscomplete",
                async (int id, bool IsComplete, IActivityService service) =>
                {
                    var result = await service.ToggleActivityStatusAsync(id, IsComplete);
                    return ToHttpResult(result);
                })
            .WithName("CompleteActivity")
            .WithDescription("Completes an existing activity using ID.")
            .WithTags("Activities")
            .RequireAuthorization()
            .Produces(StatusCodes.Status200OK)
            .Produces(StatusCodes.Status400BadRequest)
            .Produces(StatusCodes.Status500InternalServerError);


        // DELETE activity
        group.MapDelete("/activity/{id:int}", async (int id, IActivityService service) =>
            {
                var result = await service.DeleteActivityAsync(id);
                return result.IsSuccess ? Results.NoContent() : ToHttpResult(result);
            })
            .WithName("DeleteActivity")
            .WithDescription("Deletes an activity by ID.")
            .WithTags("Activities")
            .RequireAuthorization()
            .Produces(StatusCodes.Status204NoContent)
            .Produces(StatusCodes.Status404NotFound)
            .Produces(StatusCodes.Status400BadRequest)
            .Produces(StatusCodes.Status500InternalServerError);

        group.MapPost("/activity/assign-pictogram/{activityId:int}/{pictogramId:int}",
                async (int activityId, int pictogramId, IActivityService service,
                    HttpContext httpContext) =>
                {
                    var token = GetAccessToken(httpContext);
                    if (token is null)
                        return Results.Unauthorized();

                    var result = await service.AssignPictogramAsync(activityId, pictogramId, token);
                    return ToHttpResult(result);
                })
            .WithName("AssignPictogram")
            .WithDescription("Assigns a pictogram by ID.")
            .WithTags("Activities")
            .RequireAuthorization()
            .Produces(StatusCodes.Status200OK)
            .Produces(StatusCodes.Status404NotFound)
            .Produces(StatusCodes.Status500InternalServerError);


        return group;
    }
}
