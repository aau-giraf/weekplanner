using System.ComponentModel.DataAnnotations;

namespace GirafAPI.Entities.Activities;

/// An option within a choice activity. Children pick one of these.
public class ActivityOption
{
    public int Id { get; set; }

    public int ActivityId { get; set; }

    public Activity Activity { get; set; } = null!;

    [MaxLength(200)]
    public string? Title { get; set; }

    public int? PictogramId { get; set; }

    public int SortOrder { get; set; }
}
