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

    public async Task<ServiceResult<List<ActivityDTO>>> GetActivitiesByOwnerAsync(
        ActivityOwner owner, DateOnly date, string accessToken, CancellationToken ct = default)
    {
        var ownerResult = await ValidateOwnerAsync(owner, accessToken, ct);
        if (ownerResult is not null)
            return ServiceResult<List<ActivityDTO>>.Fail(ownerResult);

        var activities = await _db.Activities
            .Where(owner.ToFilter())
            .Where(a => a.Date == date)
            .OrderBy(a => a.SortOrder)
            .ThenBy(a => a.StartTime)
            .Select(a => a.ToDTO())
            .AsNoTracking()
            .ToListAsync(ct);

        return ServiceResult<List<ActivityDTO>>.Success(activities);
    }

    public async Task<ServiceResult<ActivityDTO>> GetActivityByIdAsync(int id, string accessToken, CancellationToken ct = default)
    {
        var activity = await _db.Activities
            .AsNoTracking()
            .FirstOrDefaultAsync(a => a.Id == id, ct);

        if (activity is null)
            return ServiceResult<ActivityDTO>.Fail(
                new ServiceError(ServiceErrorKind.NotFound, "Activity not found."));

        var ownerError = await ValidateActivityOwnerAsync(activity, accessToken, ct);
        if (ownerError is not null)
            return ServiceResult<ActivityDTO>.Fail(ownerError);

        return ServiceResult<ActivityDTO>.Success(activity.ToDTO());
    }

    public async Task<ServiceResult<ActivityDTO>> CreateActivityAsync(
        ActivityOwner owner, CreateActivityDTO dto, string accessToken, CancellationToken ct = default)
    {
        if ((dto.StartTime is null) != (dto.EndTime is null))
            return ServiceResult<ActivityDTO>.Fail(
                new ServiceError(ServiceErrorKind.Validation, "Start and end time must both be provided or both omitted."));

        if (dto.StartTime is not null && dto.EndTime is not null && dto.EndTime <= dto.StartTime)
            return ServiceResult<ActivityDTO>.Fail(
                new ServiceError(ServiceErrorKind.Validation, "End time must be after start time."));

        var ownerResult = await ValidateOwnerAsync(owner, accessToken, ct);
        if (ownerResult is not null)
            return ServiceResult<ActivityDTO>.Fail(ownerResult);

        if (dto.PictogramId is not null)
        {
            var picResult = await _coreClient.ValidatePictogramAsync(dto.PictogramId.Value, accessToken, ct);
            if (picResult is not CoreValidationResult.Valid)
                return ServiceResult<ActivityDTO>.Fail(ToCoreError(picResult, "Pictogram"));
        }

        var activity = dto.ToEntity();
        owner.ApplyTo(activity);

        // Auto-assign sort order if not provided
        if (dto.SortOrder is null)
        {
            var maxOrder = await _db.Activities
                .Where(owner.ToFilter())
                .Where(a => a.Date == dto.Date)
                .MaxAsync(a => (int?)a.SortOrder, ct) ?? -1;
            activity.SortOrder = maxOrder + 1;
        }

        _db.Activities.Add(activity);
        await _db.SaveChangesAsync(ct);

        return ServiceResult<ActivityDTO>.Success(activity.ToDTO());
    }

    public async Task<ServiceResult<List<ActivityDTO>>> CreateBatchActivitiesAsync(
        ActivityOwner owner, CreateBatchActivityDTO dto, string accessToken, CancellationToken ct = default)
    {
        if ((dto.StartTime is null) != (dto.EndTime is null))
            return ServiceResult<List<ActivityDTO>>.Fail(
                new ServiceError(ServiceErrorKind.Validation, "Start and end time must both be provided or both omitted."));

        if (dto.StartTime is not null && dto.EndTime is not null && dto.EndTime <= dto.StartTime)
            return ServiceResult<List<ActivityDTO>>.Fail(
                new ServiceError(ServiceErrorKind.Validation, "End time must be after start time."));

        var ownerResult = await ValidateOwnerAsync(owner, accessToken, ct);
        if (ownerResult is not null)
            return ServiceResult<List<ActivityDTO>>.Fail(ownerResult);

        if (dto.PictogramId is not null)
        {
            var picResult = await _coreClient.ValidatePictogramAsync(dto.PictogramId.Value, accessToken, ct);
            if (picResult is not CoreValidationResult.Valid)
                return ServiceResult<List<ActivityDTO>>.Fail(ToCoreError(picResult, "Pictogram"));
        }

        var created = new List<ActivityDTO>();
        foreach (var date in dto.Dates)
        {
            var activity = dto.ToEntity(date);
            owner.ApplyTo(activity);

            var maxOrder = await _db.Activities
                .Where(owner.ToFilter())
                .Where(a => a.Date == date)
                .MaxAsync(a => (int?)a.SortOrder, ct) ?? -1;
            activity.SortOrder = maxOrder + 1;

            _db.Activities.Add(activity);
            await _db.SaveChangesAsync(ct);

            created.Add(activity.ToDTO());
        }

        return ServiceResult<List<ActivityDTO>>.Success(created);
    }

    public async Task<ServiceResult<ActivityDTO>> UpdateActivityAsync(
        int id, UpdateActivityDTO dto, string accessToken, CancellationToken ct = default)
    {
        if ((dto.StartTime is null) != (dto.EndTime is null))
            return ServiceResult<ActivityDTO>.Fail(
                new ServiceError(ServiceErrorKind.Validation, "Start and end time must both be provided or both omitted."));

        if (dto.StartTime is not null && dto.EndTime is not null && dto.EndTime <= dto.StartTime)
            return ServiceResult<ActivityDTO>.Fail(
                new ServiceError(ServiceErrorKind.Validation, "End time must be after start time."));

        var activity = await _db.Activities.FindAsync([id], ct);
        if (activity is null)
            return ServiceResult<ActivityDTO>.Fail(new ServiceError(ServiceErrorKind.NotFound, "Activity not found."));

        var ownerError = await ValidateActivityOwnerAsync(activity, accessToken, ct);
        if (ownerError is not null)
            return ServiceResult<ActivityDTO>.Fail(ownerError);

        if (dto.PictogramId is not null)
        {
            var picResult = await _coreClient.ValidatePictogramAsync(dto.PictogramId.Value, accessToken, ct);
            if (picResult is not CoreValidationResult.Valid)
                return ServiceResult<ActivityDTO>.Fail(ToCoreError(picResult, "Pictogram"));
        }

        activity.Date = dto.Date;
        activity.StartTime = dto.StartTime;
        activity.EndTime = dto.EndTime;
        activity.Title = dto.Title;
        // Preserve existing sort order when client omits it (e.g. simple field edits).
        if (dto.SortOrder is not null)
            activity.SortOrder = dto.SortOrder.Value;
        activity.IsCompleted = dto.IsCompleted;
        activity.PictogramId = dto.PictogramId;
        await _db.SaveChangesAsync(ct);

        return ServiceResult<ActivityDTO>.Success(activity.ToDTO());
    }

    public async Task<ServiceResult> ToggleActivityStatusAsync(int id, bool isComplete, string accessToken, CancellationToken ct = default)
    {
        var activity = await _db.Activities.FindAsync([id], ct);
        if (activity is null)
            return ServiceResult.Fail(new ServiceError(ServiceErrorKind.NotFound, "Activity not found."));

        var ownerError = await ValidateActivityOwnerAsync(activity, accessToken, ct);
        if (ownerError is not null)
            return ServiceResult.Fail(ownerError);

        activity.IsCompleted = isComplete;
        await _db.SaveChangesAsync(ct);

        return ServiceResult.Success();
    }

    public async Task<ServiceResult> DeleteActivityAsync(int id, string accessToken, CancellationToken ct = default)
    {
        var activity = await _db.Activities.FindAsync([id], ct);
        if (activity is null)
            return ServiceResult.Fail(new ServiceError(ServiceErrorKind.NotFound, "Activity not found."));

        var ownerError = await ValidateActivityOwnerAsync(activity, accessToken, ct);
        if (ownerError is not null)
            return ServiceResult.Fail(ownerError);

        _db.Activities.Remove(activity);
        await _db.SaveChangesAsync(ct);
        return ServiceResult.Success();
    }

    public async Task<ServiceResult<ActivityDTO>> AssignPictogramAsync(
        int activityId, int pictogramId, string accessToken, CancellationToken ct = default)
    {
        var activity = await _db.Activities.FindAsync([activityId], ct);
        if (activity is null)
            return ServiceResult<ActivityDTO>.Fail(
                new ServiceError(ServiceErrorKind.NotFound, "Activity not found."));

        var ownerError = await ValidateActivityOwnerAsync(activity, accessToken, ct);
        if (ownerError is not null)
            return ServiceResult<ActivityDTO>.Fail(ownerError);

        var picResult = await _coreClient.ValidatePictogramAsync(pictogramId, accessToken, ct);
        if (picResult is not CoreValidationResult.Valid)
            return ServiceResult<ActivityDTO>.Fail(ToCoreError(picResult, "Pictogram"));

        activity.PictogramId = pictogramId;
        await _db.SaveChangesAsync(ct);

        return ServiceResult<ActivityDTO>.Success(activity.ToDTO());
    }

    public async Task<ServiceResult> CopyActivitiesAsync(
        ActivityOwner owner, DateOnly sourceDate, DateOnly targetDate, List<int> activityIds, string accessToken, CancellationToken ct = default)
    {
        var ownerResult = await ValidateOwnerAsync(owner, accessToken, ct);
        if (ownerResult is not null)
            return ServiceResult.Fail(ownerResult);

        var activities = await _db.Activities
            .Where(owner.ToFilter())
            .Where(a => a.Date == sourceDate || activityIds.Contains(a.Id))
            .AsNoTracking()
            .ToListAsync(ct);

        if (activities.Count is 0)
            return ServiceResult.Fail(
                new ServiceError(ServiceErrorKind.NotFound, "No activities found for the given date."));

        foreach (var a in activities)
        {
            var copy = new Activity
            {
                Date = targetDate,
                StartTime = a.StartTime,
                EndTime = a.EndTime,
                Title = a.Title,
                SortOrder = a.SortOrder,
                IsCompleted = false,
                PictogramId = a.PictogramId
            };
            owner.ApplyTo(copy);
            _db.Activities.Add(copy);
        }

        await _db.SaveChangesAsync(ct);
        return ServiceResult.Success();
    }

    public async Task<ServiceResult> ReorderActivitiesAsync(
        ActivityOwner owner, List<ReorderItemDTO> items, string accessToken, CancellationToken ct = default)
    {
        var ownerResult = await ValidateOwnerAsync(owner, accessToken, ct);
        if (ownerResult is not null)
            return ServiceResult.Fail(ownerResult);

        var ids = items.Select(i => i.ActivityId).ToList();
        var activities = await _db.Activities
            .Where(owner.ToFilter())
            .Where(a => ids.Contains(a.Id))
            .ToListAsync(ct);

        if (activities.Count != ids.Count)
            return ServiceResult.Fail(
                new ServiceError(ServiceErrorKind.Validation, "One or more activity IDs are invalid."));

        var orderMap = items.ToDictionary(i => i.ActivityId, i => i.SortOrder);
        foreach (var activity in activities)
            activity.SortOrder = orderMap[activity.Id];

        await _db.SaveChangesAsync(ct);
        return ServiceResult.Success();
    }

    /// <summary>
    /// Resolves the owner from an activity entity and validates access via giraf-core.
    /// Fails closed: activities with no resolvable owner are rejected.
    /// </summary>
    private async Task<ServiceError?> ValidateActivityOwnerAsync(Activity activity, string accessToken, CancellationToken ct)
    {
        var owner = ResolveOwner(activity);
        if (owner is null)
            return new ServiceError(ServiceErrorKind.Forbidden, "Access denied.");

        return await ValidateOwnerAsync(owner, accessToken, ct);
    }

    private static ActivityOwner? ResolveOwner(Activity activity) =>
        activity switch
        {
            { CitizenId: int citizenId } => new ActivityOwner.Citizen(citizenId),
            { GradeId: int gradeId } => new ActivityOwner.Grade(gradeId),
            _ => null
        };

    private async Task<ServiceError?> ValidateOwnerAsync(ActivityOwner owner, string accessToken, CancellationToken ct)
    {
        var result = owner switch
        {
            ActivityOwner.Citizen c => await _coreClient.ValidateCitizenAsync(c.Id, accessToken, ct),
            ActivityOwner.Grade g => await _coreClient.ValidateGradeAsync(g.Id, accessToken, ct),
            _ => CoreValidationResult.NotFound
        };
        return result is CoreValidationResult.Valid ? null : ToCoreError(result, OwnerLabel(owner));
    }

    private static string OwnerLabel(ActivityOwner owner) =>
        owner switch
        {
            ActivityOwner.Citizen => "Citizen",
            ActivityOwner.Grade => "Grade",
            _ => "Owner"
        };

    private static ServiceError ToCoreError(CoreValidationResult result, string entity) =>
        result switch
        {
            CoreValidationResult.Forbidden => new ServiceError(ServiceErrorKind.Forbidden, $"Not authorized to access {entity.ToLowerInvariant()}."),
            _ => new ServiceError(ServiceErrorKind.NotFound, $"{entity} not found.")
        };
}
