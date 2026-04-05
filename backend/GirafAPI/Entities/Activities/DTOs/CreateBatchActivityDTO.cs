using System.ComponentModel.DataAnnotations;

namespace GirafAPI.Entities.Activities.DTOs;

public record CreateBatchActivityDTO
(
    [Required] [MinLength(1)] List<DateOnly> Dates,
    TimeOnly? StartTime,
    TimeOnly? EndTime,
    [StringLength(200)] string? Title,
    int? PictogramId
);
