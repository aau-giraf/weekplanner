using System.ComponentModel.DataAnnotations;

namespace GirafAPI.Entities.Activities.DTOs;

public record ReorderItemDTO
(
    [Required] int ActivityId,
    [Required] int SortOrder
);
