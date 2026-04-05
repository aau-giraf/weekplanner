namespace GirafAPI.Entities.Activities.DTOs;

public record ActivityOptionDTO(
    int Id,
    string? Title,
    int? PictogramId,
    int SortOrder
);
