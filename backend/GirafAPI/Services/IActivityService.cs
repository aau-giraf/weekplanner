using GirafAPI.Entities.Activities;
using GirafAPI.Entities.Activities.DTOs;

namespace GirafAPI.Services;

public interface IActivityService
{
    Task<ServiceResult<List<ActivityDTO>>> GetActivitiesByOwnerAsync(ActivityOwner owner, DateOnly date, string accessToken, CancellationToken ct = default);
    Task<ServiceResult<ActivityDTO>> GetActivityByIdAsync(int id, string accessToken, CancellationToken ct = default);

    Task<ServiceResult<ActivityDTO>> CreateActivityAsync(
        ActivityOwner owner, CreateActivityDTO dto, string accessToken, CancellationToken ct = default);

    Task<ServiceResult> UpdateActivityAsync(
        int id, UpdateActivityDTO dto, string accessToken, CancellationToken ct = default);

    Task<ServiceResult> ToggleActivityStatusAsync(int id, bool isComplete, string accessToken, CancellationToken ct = default);
    Task<ServiceResult> DeleteActivityAsync(int id, string accessToken, CancellationToken ct = default);

    Task<ServiceResult<ActivityDTO>> AssignPictogramAsync(
        int activityId, int pictogramId, string accessToken, CancellationToken ct = default);

    Task<ServiceResult> CopyActivitiesAsync(
        ActivityOwner owner, DateOnly sourceDate, DateOnly targetDate, List<int> activityIds, string accessToken, CancellationToken ct = default);
}
