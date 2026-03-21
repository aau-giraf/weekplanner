using System.Linq.Expressions;

namespace GirafAPI.Entities.Activities;

/// <summary>
/// Discriminated union representing who owns an activity — either a Citizen or a Grade.
/// Used to eliminate duplicate citizen/grade methods throughout the service layer.
/// </summary>
public abstract record ActivityOwner
{
    public record Citizen(int Id) : ActivityOwner;
    public record Grade(int Id) : ActivityOwner;

    /// <summary>
    /// Returns an EF-compatible filter expression matching activities belonging to this owner.
    /// </summary>
    public Expression<Func<Activity, bool>> ToFilter() => this switch
    {
        Citizen c => a => a.CitizenId == c.Id,
        Grade g => a => a.GradeId == g.Id,
        _ => throw new InvalidOperationException("Unknown ActivityOwner variant.")
    };

    /// <summary>
    /// Sets the appropriate ownership field (CitizenId or GradeId) on an Activity entity.
    /// </summary>
    public void ApplyTo(Activity activity)
    {
        switch (this)
        {
            case Citizen c:
                activity.CitizenId = c.Id;
                break;
            case Grade g:
                activity.GradeId = g.Id;
                break;
        }
    }
}
