using System.ComponentModel.DataAnnotations;

namespace GirafAPI.Entities.Activities.DTOs;

public record CreateActivityDTO(
    [Required] DateOnly Date,
    TimeOnly? StartTime = null,
    TimeOnly? EndTime = null,
    [StringLength(200)] string? Title = null,
    int? SortOrder = null,
    int? PictogramId = null,
    List<CreateActivityOptionDTO>? Options = null
);
