using System.ComponentModel.DataAnnotations;

namespace GirafAPI.Entities.Activities.DTOs;

public record ActivityDTO
(
    [Required] int ActivityId,
    [Required] DateOnly Date,
    TimeOnly? StartTime,
    TimeOnly? EndTime,
    string? Title,
    int SortOrder,
    bool IsCompleted,
    int? PictogramId,
    int? SelectedOptionIndex,
    List<ActivityOptionDTO> Options
);
