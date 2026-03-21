using System.ComponentModel.DataAnnotations;

namespace GirafAPI.Entities.Activities.DTOs;

public record ActivityDTO
(
    [Required] int ActivityId,
    [Required] DateOnly Date,
    [Required] TimeOnly StartTime,
    [Required] TimeOnly EndTime,
    bool IsCompleted,
    int? PictogramId
);
