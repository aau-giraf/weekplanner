using System.ComponentModel.DataAnnotations;

namespace GirafAPI.Entities.Activities.DTOs;

public record UpdateActivityDTO
(
    [Required] DateOnly Date,
    TimeOnly? StartTime,
    TimeOnly? EndTime,
    string? Title,
    int? SortOrder,
    [Required] bool IsCompleted,
    int? PictogramId
);
