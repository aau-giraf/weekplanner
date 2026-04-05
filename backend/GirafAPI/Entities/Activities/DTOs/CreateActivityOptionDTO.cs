using System.ComponentModel.DataAnnotations;

namespace GirafAPI.Entities.Activities.DTOs;

public record CreateActivityOptionDTO(
    [StringLength(200)] string? Title,
    int? PictogramId
);
