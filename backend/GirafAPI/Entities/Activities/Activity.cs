using System.ComponentModel.DataAnnotations;

namespace GirafAPI.Entities.Activities;

// Data model of one activity in a day
public class Activity
{
    public int Id { get; set; }

    public required DateOnly Date { get; set; }

    public TimeOnly? StartTime { get; set; }

    public TimeOnly? EndTime { get; set; }

    [MaxLength(200)]
    public string? Title { get; set; }

    public int SortOrder { get; set; }

    public bool IsCompleted { get; set; }

    public int? CitizenId { get; set; }

    public int? GradeId { get; set; }

    public int? PictogramId { get; set; }
}
