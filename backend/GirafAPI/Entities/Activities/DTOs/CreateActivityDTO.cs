using System.ComponentModel.DataAnnotations;

namespace GirafAPI.Entities.Activities.DTOs;

public record CreateActivityDTO
(
    [Required] DateOnly Date,
    TimeOnly? StartTime,
    TimeOnly? EndTime,
    string? Title,
    int? SortOrder,
    int? PictogramId
);
