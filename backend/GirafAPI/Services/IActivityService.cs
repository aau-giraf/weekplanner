using GirafAPI.Entities.Activities.DTOs;

namespace GirafAPI.Services;

public interface IActivityService
{
    Task<ServiceResult<List<ActivityDTO>>> GetAllActivitiesAsync();
    Task<ServiceResult<List<ActivityDTO>>> GetActivitiesByCitizenAsync(int citizenId, string date);
    Task<ServiceResult<List<ActivityDTO>>> GetActivitiesByGradeAsync(int gradeId, string date);
    Task<ServiceResult<ActivityDTO>> GetActivityByIdAsync(int id);

    Task<ServiceResult<ActivityDTO>> CreateActivityForCitizenAsync(
        int citizenId, CreateActivityDTO dto, string accessToken);

    Task<ServiceResult<ActivityDTO>> CreateActivityForGradeAsync(
        int gradeId, CreateActivityDTO dto, string accessToken);

    Task<ServiceResult> UpdateActivityAsync(
        int id, UpdateActivityDTO dto, string accessToken);

    Task<ServiceResult> ToggleActivityStatusAsync(int id, bool isComplete);
    Task<ServiceResult> DeleteActivityAsync(int id);

    Task<ServiceResult<ActivityDTO>> AssignPictogramAsync(
        int activityId, int pictogramId, string accessToken);

    Task<ServiceResult> CopyActivitiesForCitizenAsync(
        int citizenId, string sourceDate, string targetDate, List<int> activityIds);

    Task<ServiceResult> CopyActivitiesForGradeAsync(
        int gradeId, string sourceDate, string targetDate, List<int> activityIds);
}
