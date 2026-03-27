using GirafAPI.Data;
using GirafAPI.Entities.Activities;

namespace Giraf.IntegrationTests.Utils.DbSeeders;

/// <summary>
/// Seeds an activity with no CitizenId and no GradeId (orphaned).
/// Used to test the fail-closed authorization path.
/// </summary>
public class OrphanedActivityDb : DbSeeder
{
    public override void SeedData(GirafDbContext dbContext)
    {
        var activity = new Activity
        {
            Date = DateOnly.FromDateTime(DateTime.UtcNow),
            StartTime = TimeOnly.FromDateTime(DateTime.UtcNow),
            EndTime = TimeOnly.FromDateTime(DateTime.UtcNow.AddHours(1)),
            IsCompleted = false,
            CitizenId = null,
            GradeId = null,
            PictogramId = 1
        };

        dbContext.Activities.Add(activity);
        dbContext.SaveChanges();
        Activities.Add(activity);
    }
}
