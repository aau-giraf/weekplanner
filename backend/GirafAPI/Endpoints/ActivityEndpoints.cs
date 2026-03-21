using GirafAPI.Entities.Activities;
using GirafAPI.Entities.Activities.DTOs;
using GirafAPI.Services;
using Microsoft.AspNetCore.Http.HttpResults;

using ActivityListResult = Microsoft.AspNetCore.Http.HttpResults.Results<Microsoft.AspNetCore.Http.HttpResults.Ok<System.Collections.Generic.List<GirafAPI.Entities.Activities.DTOs.ActivityDTO>>, Microsoft.AspNetCore.Http.HttpResults.NotFound<string>, Microsoft.AspNetCore.Http.HttpResults.BadRequest<string>, Microsoft.AspNetCore.Http.HttpResults.UnauthorizedHttpResult, Microsoft.AspNetCore.Http.HttpResults.ProblemHttpResult>;
using ActivityDtoResult = Microsoft.AspNetCore.Http.HttpResults.Results<Microsoft.AspNetCore.Http.HttpResults.Ok<GirafAPI.Entities.Activities.DTOs.ActivityDTO>, Microsoft.AspNetCore.Http.HttpResults.NotFound<string>, Microsoft.AspNetCore.Http.HttpResults.BadRequest<string>, Microsoft.AspNetCore.Http.HttpResults.UnauthorizedHttpResult, Microsoft.AspNetCore.Http.HttpResults.ProblemHttpResult>;
using CreatedActivityDtoResult = Microsoft.AspNetCore.Http.HttpResults.Results<Microsoft.AspNetCore.Http.HttpResults.Created<GirafAPI.Entities.Activities.DTOs.ActivityDTO>, Microsoft.AspNetCore.Http.HttpResults.NotFound<string>, Microsoft.AspNetCore.Http.HttpResults.BadRequest<string>, Microsoft.AspNetCore.Http.HttpResults.UnauthorizedHttpResult, Microsoft.AspNetCore.Http.HttpResults.ProblemHttpResult>;
using OkNoPayloadResult = Microsoft.AspNetCore.Http.HttpResults.Results<Microsoft.AspNetCore.Http.HttpResults.Ok, Microsoft.AspNetCore.Http.HttpResults.NotFound<string>, Microsoft.AspNetCore.Http.HttpResults.BadRequest<string>, Microsoft.AspNetCore.Http.HttpResults.UnauthorizedHttpResult, Microsoft.AspNetCore.Http.HttpResults.ProblemHttpResult>;
using OkStringResult = Microsoft.AspNetCore.Http.HttpResults.Results<Microsoft.AspNetCore.Http.HttpResults.Ok<string>, Microsoft.AspNetCore.Http.HttpResults.NotFound<string>, Microsoft.AspNetCore.Http.HttpResults.BadRequest<string>, Microsoft.AspNetCore.Http.HttpResults.UnauthorizedHttpResult, Microsoft.AspNetCore.Http.HttpResults.ProblemHttpResult>;
using NoContentResult = Microsoft.AspNetCore.Http.HttpResults.Results<Microsoft.AspNetCore.Http.HttpResults.NoContent, Microsoft.AspNetCore.Http.HttpResults.NotFound<string>, Microsoft.AspNetCore.Http.HttpResults.BadRequest<string>, Microsoft.AspNetCore.Http.HttpResults.UnauthorizedHttpResult, Microsoft.AspNetCore.Http.HttpResults.ProblemHttpResult>;

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

    private static OkNoPayloadResult ToOkResult(ServiceResult result) =>
        result.IsSuccess
            ? TypedResults.Ok()
            : result.Error!.Kind switch
            {
                ServiceErrorKind.NotFound => TypedResults.NotFound(result.Error.Message),
                ServiceErrorKind.Validation => TypedResults.BadRequest(result.Error.Message),
                ServiceErrorKind.Unauthorized => TypedResults.Unauthorized(),
                _ => TypedResults.Problem(result.Error.Message,
                    statusCode: StatusCodes.Status500InternalServerError)
            };

    private static ActivityListResult ToActivityListResult(ServiceResult<List<ActivityDTO>> result) =>
        result.IsSuccess
            ? TypedResults.Ok(result.Value!)
            : result.Error!.Kind switch
            {
                ServiceErrorKind.NotFound => TypedResults.NotFound(result.Error.Message),
                ServiceErrorKind.Validation => TypedResults.BadRequest(result.Error.Message),
                ServiceErrorKind.Unauthorized => TypedResults.Unauthorized(),
                _ => TypedResults.Problem(result.Error.Message,
                    statusCode: StatusCodes.Status500InternalServerError)
            };

    private static ActivityDtoResult ToActivityDtoResult(ServiceResult<ActivityDTO> result) =>
        result.IsSuccess
            ? TypedResults.Ok(result.Value!)
            : result.Error!.Kind switch
            {
                ServiceErrorKind.NotFound => TypedResults.NotFound(result.Error.Message),
                ServiceErrorKind.Validation => TypedResults.BadRequest(result.Error.Message),
                ServiceErrorKind.Unauthorized => TypedResults.Unauthorized(),
                _ => TypedResults.Problem(result.Error.Message,
                    statusCode: StatusCodes.Status500InternalServerError)
            };

    private static CreatedActivityDtoResult ToCreatedActivityDtoResult(ServiceResult<ActivityDTO> result) =>
        result.IsSuccess
            ? TypedResults.Created($"/activity/{result.Value!.ActivityId}", result.Value)
            : result.Error!.Kind switch
            {
                ServiceErrorKind.NotFound => TypedResults.NotFound(result.Error.Message),
                ServiceErrorKind.Validation => TypedResults.BadRequest(result.Error.Message),
                ServiceErrorKind.Unauthorized => TypedResults.Unauthorized(),
                _ => TypedResults.Problem(result.Error.Message,
                    statusCode: StatusCodes.Status500InternalServerError)
            };

    private static OkStringResult ToOkStringResult(ServiceResult result, string successMessage) =>
        result.IsSuccess
            ? TypedResults.Ok(successMessage)
            : result.Error!.Kind switch
            {
                ServiceErrorKind.NotFound => TypedResults.NotFound(result.Error.Message),
                ServiceErrorKind.Validation => TypedResults.BadRequest(result.Error.Message),
                ServiceErrorKind.Unauthorized => TypedResults.Unauthorized(),
                _ => TypedResults.Problem(result.Error.Message,
                    statusCode: StatusCodes.Status500InternalServerError)
            };

    private static NoContentResult ToNoContentResult(ServiceResult result) =>
        result.IsSuccess
            ? TypedResults.NoContent()
            : result.Error!.Kind switch
            {
                ServiceErrorKind.NotFound => TypedResults.NotFound(result.Error.Message),
                ServiceErrorKind.Validation => TypedResults.BadRequest(result.Error.Message),
                ServiceErrorKind.Unauthorized => TypedResults.Unauthorized(),
                _ => TypedResults.Problem(result.Error.Message,
                    statusCode: StatusCodes.Status500InternalServerError)
            };

    public static RouteGroupBuilder MapActivityEndpoints(this WebApplication app)
    {
        var group = app.MapGroup("weekplan");

        // GET all activities (mainly for debugging)
        group.MapGet("/", async Task<ActivityListResult> (IActivityService service, CancellationToken ct) =>
            {
                var result = await service.GetAllActivitiesAsync(ct);
                return ToActivityListResult(result);
            })
            .WithName("GetAllActivities")
            .WithDescription("Gets all activities.")
            .WithTags("Activities")
            .RequireAuthorization()
            .Produces<List<ActivityDTO>>(StatusCodes.Status200OK)
            .Produces(StatusCodes.Status500InternalServerError);


        // GET activities for one day for a citizen
        group.MapGet("/{citizenId:int}", async Task<ActivityListResult> (int citizenId, DateOnly date,
                IActivityService service, CancellationToken ct) =>
            {
                var result = await service.GetActivitiesByOwnerAsync(
                    new ActivityOwner.Citizen(citizenId), date, ct);
                return ToActivityListResult(result);
            })
            .WithName("GetActivitiesForCitizenOnDate")
            .WithDescription("Gets activities for a specific citizen on a given date.")
            .WithTags("Activities")
            .RequireAuthorization()
            .Produces<List<ActivityDTO>>(StatusCodes.Status200OK)
            .Produces(StatusCodes.Status500InternalServerError);

        // GET activities for one day for a grade
        group.MapGet("/grade/{gradeId:int}", async Task<ActivityListResult> (int gradeId, DateOnly date,
                IActivityService service, CancellationToken ct) =>
            {
                var result = await service.GetActivitiesByOwnerAsync(
                    new ActivityOwner.Grade(gradeId), date, ct);
                return ToActivityListResult(result);
            })
            .WithName("GetActivitiesForGradeOnDate")
            .WithDescription("Gets activities for a specific grade on a given date.")
            .WithTags("Activities")
            .RequireAuthorization()
            .Produces<List<ActivityDTO>>(StatusCodes.Status200OK)
            .Produces(StatusCodes.Status404NotFound)
            .Produces(StatusCodes.Status500InternalServerError);


        // GET single activity by ID
        group.MapGet("/activity/{id:int}", async Task<ActivityDtoResult> (int id, IActivityService service, CancellationToken ct) =>
            {
                var result = await service.GetActivityByIdAsync(id, ct);
                return ToActivityDtoResult(result);
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
                    HttpContext httpContext, CancellationToken ct) =>
                {
                    var token = GetAccessToken(httpContext);
                    if (token is null)
                        return TypedResults.Unauthorized();

                    var result = await service.CreateActivityAsync(
                        new ActivityOwner.Citizen(citizenId), dto, token, ct);
                    return ToCreatedActivityDtoResult(result);
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
                    HttpContext httpContext, CancellationToken ct) =>
                {
                    var token = GetAccessToken(httpContext);
                    if (token is null)
                        return TypedResults.Unauthorized();

                    var result = await service.CreateActivityAsync(
                        new ActivityOwner.Grade(gradeId), dto, token, ct);
                    return ToCreatedActivityDtoResult(result);
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
                async (int citizenId, DateOnly sourceDate, DateOnly targetDate, List<int> toCopyIds,
                    IActivityService service, CancellationToken ct) =>
                {
                    var result = await service.CopyActivitiesAsync(
                        new ActivityOwner.Citizen(citizenId), sourceDate, targetDate, toCopyIds, ct);
                    return ToOkStringResult(result, "Activities successfully copied.");
                })
            .WithName("CopyActivityForCitizen")
            .WithDescription("Copies activities between days for a citizen")
            .WithTags("Activities")
            .RequireAuthorization()
            .Produces(StatusCodes.Status400BadRequest)
            .Produces(StatusCodes.Status200OK);

        group.MapPost("/activity/copy-grade/{gradeId:int}",
                async (int gradeId, DateOnly sourceDate, DateOnly targetDate, List<int> toCopyIds,
                    IActivityService service, CancellationToken ct) =>
                {
                    var result = await service.CopyActivitiesAsync(
                        new ActivityOwner.Grade(gradeId), sourceDate, targetDate, toCopyIds, ct);
                    return ToOkStringResult(result, "Activities successfully copied.");
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
                    HttpContext httpContext, CancellationToken ct) =>
                {
                    var token = GetAccessToken(httpContext);
                    if (token is null)
                        return TypedResults.Unauthorized();

                    var result = await service.UpdateActivityAsync(id, dto, token, ct);
                    return ToOkResult(result);
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
                async (int id, bool IsComplete, IActivityService service, CancellationToken ct) =>
                {
                    var result = await service.ToggleActivityStatusAsync(id, IsComplete, ct);
                    return ToOkResult(result);
                })
            .WithName("CompleteActivity")
            .WithDescription("Completes an existing activity using ID.")
            .WithTags("Activities")
            .RequireAuthorization()
            .Produces(StatusCodes.Status200OK)
            .Produces(StatusCodes.Status400BadRequest)
            .Produces(StatusCodes.Status500InternalServerError);


        // DELETE activity
        group.MapDelete("/activity/{id:int}", async (int id, IActivityService service, CancellationToken ct) =>
            {
                var result = await service.DeleteActivityAsync(id, ct);
                return ToNoContentResult(result);
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
                    HttpContext httpContext, CancellationToken ct) =>
                {
                    var token = GetAccessToken(httpContext);
                    if (token is null)
                        return TypedResults.Unauthorized();

                    var result = await service.AssignPictogramAsync(activityId, pictogramId, token, ct);
                    return ToActivityDtoResult(result);
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
