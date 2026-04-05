using GirafAPI.Entities.Activities;
using GirafAPI.Entities.Activities.DTOs;

namespace GirafAPI.Mapping;

public static class ActivityMapping
{
    public static Activity ToEntity(this CreateActivityDTO dto)
    {
        var activity = new Activity
        {
            Date = dto.Date,
            StartTime = dto.StartTime,
            EndTime = dto.EndTime,
            Title = dto.Title,
            SortOrder = dto.SortOrder ?? 0,
            IsCompleted = false,
            PictogramId = dto.PictogramId,
        };

        if (dto.Options is { Count: > 0 })
        {
            activity.Options = dto.Options.Select((o, i) => new ActivityOption
            {
                Title = o.Title,
                PictogramId = o.PictogramId,
                SortOrder = i,
            }).ToList();
        }

        return activity;
    }

    public static Activity ToEntity(this CreateBatchActivityDTO dto, DateOnly date)
    {
        return new Activity
        {
            Date = date,
            StartTime = dto.StartTime,
            EndTime = dto.EndTime,
            Title = dto.Title,
            SortOrder = 0,
            IsCompleted = false,
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
            activity.PictogramId,
            activity.SelectedOptionIndex,
            activity.Options.Select(o => o.ToDTO()).ToList()
        );
    }

    public static ActivityOptionDTO ToDTO(this ActivityOption option)
    {
        return new ActivityOptionDTO(
            option.Id,
            option.Title,
            option.PictogramId,
            option.SortOrder
        );
    }
}
