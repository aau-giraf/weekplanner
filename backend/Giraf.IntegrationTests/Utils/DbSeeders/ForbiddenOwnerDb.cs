using GirafAPI.Data;

namespace Giraf.IntegrationTests.Utils.DbSeeders;

/// <summary>
/// Seeds an activity owned by citizenId=101, which falls in the StubCoreClient's Forbidden range.
/// Used to test authorization-failure paths.
/// </summary>
public class ForbiddenOwnerDb : DbSeeder
{
    public override void SeedData(GirafDbContext dbContext)
    {
        SeedCitizenActivity(dbContext, citizenId: 101, pictogramId: 1);
    }
}
