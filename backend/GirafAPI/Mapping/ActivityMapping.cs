using GirafAPI.Entities.Activities;
using GirafAPI.Entities.Activities.DTOs;

namespace GirafAPI.Mapping;

public static class ActivityMapping
{
    public static Activity ToEntity(this CreateActivityDTO dto)
    {
        return new Activity
        {
            Date = dto.Date,
            StartTime = dto.StartTime,
            EndTime = dto.EndTime,
            Title = dto.Title,
            SortOrder = dto.SortOrder ?? 0,
            IsCompleted = false,
            PictogramId = dto.PictogramId
        };
    }

    public static Activity ToEntity(this UpdateActivityDTO dto, int id)
    {
        return new Activity
        {
            Id = id,
            Date = dto.Date,
            StartTime = dto.StartTime,
            EndTime = dto.EndTime,
            Title = dto.Title,
            SortOrder = dto.SortOrder ?? 0,
            IsCompleted = dto.IsCompleted,
            PictogramId = dto.PictogramId
        };
    }

    public static ActivityDTO ToDTO(this Activity activity)
    {
        return new ActivityDTO(
            activity.Id,
            activity.Date,
            activity.StartTime,
            activity.EndTime,
            activity.Title,
            activity.SortOrder,
            activity.IsCompleted,
            activity.PictogramId
        );
    }
}
