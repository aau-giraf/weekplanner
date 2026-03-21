using GirafAPI.Clients;
using GirafAPI.Data;
using GirafAPI.Entities.Activities;
using GirafAPI.Entities.Activities.DTOs;
using GirafAPI.Mapping;
using Microsoft.EntityFrameworkCore;

namespace GirafAPI.Services;

public class ActivityService : IActivityService
{
    private readonly GirafDbContext _db;
    private readonly ICoreClient _coreClient;

    public ActivityService(GirafDbContext db, ICoreClient coreClient)
    {
        _db = db;
        _coreClient = coreClient;
    }

    public async Task<ServiceResult<List<ActivityDTO>>> GetAllActivitiesAsync()
    {
        var activities = await _db.Activities
            .Select(a => a.ToDTO())
            .AsNoTracking()
            .ToListAsync();

        return ServiceResult<List<ActivityDTO>>.Success(activities);
    }

    public async Task<ServiceResult<List<ActivityDTO>>> GetActivitiesByOwnerAsync(ActivityOwner owner, string date)
    {
        if (!DateOnly.TryParse(date, out var parsedDate))
            return ServiceResult<List<ActivityDTO>>.Fail(
                new ServiceError(ServiceErrorKind.Validation, "Invalid date format."));

        var activities = await _db.Activities
            .Where(owner.ToFilter())
            .Where(a => a.Date == parsedDate)
            .Select(a => a.ToDTO())
            .AsNoTracking()
            .ToListAsync();

        return owner is ActivityOwner.Grade && activities.Count == 0
            ? ServiceResult<List<ActivityDTO>>.Fail(
                new ServiceError(ServiceErrorKind.NotFound, "No activities found for the given date."))
            : ServiceResult<List<ActivityDTO>>.Success(activities);
    }

    public async Task<ServiceResult<ActivityDTO>> GetActivityByIdAsync(int id)
    {
        var activity = await _db.Activities
            .AsNoTracking()
            .FirstOrDefaultAsync(a => a.Id == id);

        return activity is null
            ? ServiceResult<ActivityDTO>.Fail(
                new ServiceError(ServiceErrorKind.NotFound, "Activity not found."))
            : ServiceResult<ActivityDTO>.Success(activity.ToDTO());
    }

    public async Task<ServiceResult<ActivityDTO>> CreateActivityAsync(
        ActivityOwner owner, CreateActivityDTO dto, string accessToken)
    {
        var validationError = ValidateActivityTimes(dto.Date, dto.StartTime, dto.EndTime);
        if (validationError is not null)
            return ServiceResult<ActivityDTO>.Fail(
                new ServiceError(ServiceErrorKind.Validation, validationError));

        if (!await ValidateOwnerAsync(owner, accessToken))
            return ServiceResult<ActivityDTO>.Fail(
                new ServiceError(ServiceErrorKind.NotFound, OwnerNotFoundMessage(owner)));

        if (dto.PictogramId is not null &&
            !await _coreClient.ValidatePictogramAsync(dto.PictogramId.Value, accessToken))
            return ServiceResult<ActivityDTO>.Fail(
                new ServiceError(ServiceErrorKind.NotFound, "Pictogram not found."));

        var activity = dto.ToEntity();
        owner.ApplyTo(activity);

        _db.Activities.Add(activity);
        await _db.SaveChangesAsync();

        return ServiceResult<ActivityDTO>.Success(activity.ToDTO());
    }

    public async Task<ServiceResult> UpdateActivityAsync(
        int id, UpdateActivityDTO dto, string accessToken)
    {
        var validationError = ValidateActivityTimes(dto.Date, dto.StartTime, dto.EndTime);
        if (validationError is not null)
            return ServiceResult.Fail(new ServiceError(ServiceErrorKind.Validation, validationError));

        var activity = await _db.Activities.FindAsync(id);
        if (activity is null)
            return ServiceResult.Fail(new ServiceError(ServiceErrorKind.NotFound, "Activity not found."));

        if (dto.PictogramId is not null &&
            !await _coreClient.ValidatePictogramAsync(dto.PictogramId.Value, accessToken))
            return ServiceResult.Fail(
                new ServiceError(ServiceErrorKind.Validation, "Pictogram not found."));

        activity.Date = DateOnly.Parse(dto.Date);
        activity.StartTime = TimeOnly.Parse(dto.StartTime);
        activity.EndTime = TimeOnly.Parse(dto.EndTime);
        activity.IsCompleted = dto.IsCompleted;
        activity.PictogramId = dto.PictogramId;
        await _db.SaveChangesAsync();

        return ServiceResult.Success();
    }

    public async Task<ServiceResult> ToggleActivityStatusAsync(int id, bool isComplete)
    {
        var activity = await _db.Activities.FindAsync(id);
        if (activity is null)
            return ServiceResult.Fail(new ServiceError(ServiceErrorKind.NotFound, "Activity not found."));

        activity.IsCompleted = isComplete;
        await _db.SaveChangesAsync();

        return ServiceResult.Success();
    }

    public async Task<ServiceResult> DeleteActivityAsync(int id)
    {
        var rowsAffected = await _db.Activities.Where(a => a.Id == id).ExecuteDeleteAsync();
        return rowsAffected == 0
            ? ServiceResult.Fail(new ServiceError(ServiceErrorKind.NotFound, "Activity not found."))
            : ServiceResult.Success();
    }

    public async Task<ServiceResult<ActivityDTO>> AssignPictogramAsync(
        int activityId, int pictogramId, string accessToken)
    {
        var activity = await _db.Activities.FindAsync(activityId);
        if (activity is null)
            return ServiceResult<ActivityDTO>.Fail(
                new ServiceError(ServiceErrorKind.NotFound, "Activity not found."));

        if (!await _coreClient.ValidatePictogramAsync(pictogramId, accessToken))
            return ServiceResult<ActivityDTO>.Fail(
                new ServiceError(ServiceErrorKind.NotFound, "Pictogram not found."));

        activity.PictogramId = pictogramId;
        await _db.SaveChangesAsync();

        return ServiceResult<ActivityDTO>.Success(activity.ToDTO());
    }

    public async Task<ServiceResult> CopyActivitiesAsync(
        ActivityOwner owner, string sourceDate, string targetDate, List<int> activityIds)
    {
        if (!DateOnly.TryParse(sourceDate, out var source))
            return ServiceResult.Fail(new ServiceError(ServiceErrorKind.Validation, "Invalid source date format."));
        if (!DateOnly.TryParse(targetDate, out var target))
            return ServiceResult.Fail(new ServiceError(ServiceErrorKind.Validation, "Invalid target date format."));

        var activities = await _db.Activities
            .Where(owner.ToFilter())
            .Where(a => a.Date == source || activityIds.Contains(a.Id))
            .AsNoTracking()
            .ToListAsync();

        if (activities.Count is 0)
            return ServiceResult.Fail(
                new ServiceError(ServiceErrorKind.NotFound, "No activities found for the given date."));

        foreach (var a in activities)
        {
            var copy = new Activity
            {
                Date = target,
                StartTime = a.StartTime,
                EndTime = a.EndTime,
                IsCompleted = false,
                PictogramId = a.PictogramId
            };
            owner.ApplyTo(copy);
            _db.Activities.Add(copy);
        }

        await _db.SaveChangesAsync();
        return ServiceResult.Success();
    }

    private async Task<bool> ValidateOwnerAsync(ActivityOwner owner, string accessToken) =>
        owner switch
        {
            ActivityOwner.Citizen c => await _coreClient.ValidateCitizenAsync(c.Id, accessToken),
            ActivityOwner.Grade g => await _coreClient.ValidateGradeAsync(g.Id, accessToken),
            _ => false
        };

    private static string OwnerNotFoundMessage(ActivityOwner owner) =>
        owner switch
        {
            ActivityOwner.Citizen => "Citizen not found.",
            ActivityOwner.Grade => "Grade not found.",
            _ => "Owner not found."
        };

    private static string? ValidateActivityTimes(string date, string startTime, string endTime)
    {
        if (!DateOnly.TryParse(date, out _))
            return "Invalid date format.";
        if (!TimeOnly.TryParse(startTime, out var start))
            return "Invalid start time format.";
        if (!TimeOnly.TryParse(endTime, out var end))
            return "Invalid end time format.";
        if (end <= start)
            return "End time must be after start time.";
        return null;
    }
}
