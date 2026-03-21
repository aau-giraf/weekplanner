using GirafAPI.Entities.Activities;
using GirafAPI.Entities.Activities.DTOs;

namespace GirafAPI.Services;

public interface IActivityService
{
    Task<ServiceResult<List<ActivityDTO>>> GetAllActivitiesAsync();
    Task<ServiceResult<List<ActivityDTO>>> GetActivitiesByOwnerAsync(ActivityOwner owner, string date);
    Task<ServiceResult<ActivityDTO>> GetActivityByIdAsync(int id);

    Task<ServiceResult<ActivityDTO>> CreateActivityAsync(
        ActivityOwner owner, CreateActivityDTO dto, string accessToken);

    Task<ServiceResult> UpdateActivityAsync(
        int id, UpdateActivityDTO dto, string accessToken);

    Task<ServiceResult> ToggleActivityStatusAsync(int id, bool isComplete);
    Task<ServiceResult> DeleteActivityAsync(int id);

    Task<ServiceResult<ActivityDTO>> AssignPictogramAsync(
        int activityId, int pictogramId, string accessToken);

    Task<ServiceResult> CopyActivitiesAsync(
        ActivityOwner owner, string sourceDate, string targetDate, List<int> activityIds);
}
