using System.ComponentModel.DataAnnotations;

namespace GirafAPI.Entities.Activities.DTOs;

public record CreateActivityDTO
(
    [Required] DateOnly Date,
    TimeOnly? StartTime,
    TimeOnly? EndTime,
    [StringLength(200)] string? Title,
    int? SortOrder,
    int? PictogramId
);
