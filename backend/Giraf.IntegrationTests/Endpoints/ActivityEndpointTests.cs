using System.Net;
using System.Net.Http.Json;
using System.Text;
using Giraf.IntegrationTests.Utils;
using Giraf.IntegrationTests.Utils.DbSeeders;
using GirafAPI.Data;
using GirafAPI.Entities.Activities.DTOs;
using Microsoft.Extensions.DependencyInjection;

namespace Giraf.IntegrationTests.Endpoints
{
    [Collection("IntegrationTests")]
    public class ActivityEndpointTests
    {
        #region GET /weekplan/{citizenId:int} - Get activities for a citizen on a date

        [Fact]
        public async Task GetActivitiesForCitizenOnDate_ReturnsActivities_WhenActivitiesExist()
        {
            var factory = new GirafWebApplicationFactory(stubCoreClient: true);
            var seeder = new BaseCaseDb();
            var scope = factory.Services.CreateScope();
            factory.SeedDb(scope, seeder);
            var client = factory.CreateClient();
            client.AttachClaimsToken(role: "admin");

            var date = DateTime.UtcNow.Date.ToString("yyyy-MM-dd");
            var response = await client.GetAsync($"/weekplan/1?date={date}");

            response.EnsureSuccessStatusCode();
            var activities = await response.Content.ReadFromJsonAsync<List<ActivityDTO>>();
            Assert.NotNull(activities);
            Assert.NotEmpty(activities);
        }

        [Fact]
        public async Task GetActivitiesForCitizenOnDate_ReturnsNotFound_WhenCitizenDoesNotExist()
        {
            var factory = new GirafWebApplicationFactory(stubCoreClient: true);
            var seeder = new EmptyDb();
            var scope = factory.Services.CreateScope();
            factory.SeedDb(scope, seeder);
            var client = factory.CreateClient();
            client.AttachClaimsToken(role: "admin");

            var date = DateTime.UtcNow.Date.ToString("yyyy-MM-dd");
            var response = await client.GetAsync($"/weekplan/999?date={date}");

            Assert.Equal(HttpStatusCode.NotFound, response.StatusCode);
        }

        #endregion

        #region GET /weekplan/grade/{gradeId:int} - Get activities for a grade on a date

        [Fact]
        public async Task GetActivitiesForGradeOnDate_ReturnsActivities_WhenActivitiesExist()
        {
            var factory = new GirafWebApplicationFactory(stubCoreClient: true);
            var seeder = new BaseCaseDb();
            var scope = factory.Services.CreateScope();
            factory.SeedDb(scope, seeder);
            var client = factory.CreateClient();
            client.AttachClaimsToken(role: "member");

            var date = DateTime.UtcNow.Date.ToString("yyyy-MM-dd");
            var response = await client.GetAsync($"/weekplan/grade/1?date={date}");

            response.EnsureSuccessStatusCode();
            var activities = await response.Content.ReadFromJsonAsync<List<ActivityDTO>>();
            Assert.NotNull(activities);
            Assert.NotEmpty(activities);
        }

        [Fact]
        public async Task GetActivitiesForGradeOnDate_ReturnsNotFound_WhenNoActivities()
        {
            var factory = new GirafWebApplicationFactory(stubCoreClient: true);
            var seeder = new EmptyDb();
            var scope = factory.Services.CreateScope();
            factory.SeedDb(scope, seeder);
            var client = factory.CreateClient();
            client.AttachClaimsToken(role: "member");

            var date = DateTime.UtcNow.Date.ToString("yyyy-MM-dd");
            var response = await client.GetAsync($"/weekplan/grade/999?date={date}");

            Assert.Equal(HttpStatusCode.NotFound, response.StatusCode);
        }

        #endregion

        #region GET /weekplan/activity/{id:int} - Get activity by ID

        [Fact]
        public async Task GetActivityById_ReturnsActivity_WhenActivityExists()
        {
            var factory = new GirafWebApplicationFactory(stubCoreClient: true);
            var seeder = new BaseCaseDb();
            var scope = factory.Services.CreateScope();
            factory.SeedDb(scope, seeder);
            var client = factory.CreateClient();
            client.AttachClaimsToken(role: "member");

            int activityId = seeder.Activities[0].Id;
            var response = await client.GetAsync($"/weekplan/activity/{activityId}");

            response.EnsureSuccessStatusCode();
            var activityDto = await response.Content.ReadFromJsonAsync<ActivityDTO>();
            Assert.NotNull(activityDto);
            Assert.Equal(activityId, activityDto.ActivityId);
        }

        [Fact]
        public async Task GetActivityById_ReturnsNotFound_WhenActivityDoesNotExist()
        {
            var factory = new GirafWebApplicationFactory(stubCoreClient: true);
            var seeder = new EmptyDb();
            var scope = factory.Services.CreateScope();
            factory.SeedDb(scope, seeder);
            var client = factory.CreateClient();
            client.AttachClaimsToken(role: "member");

            var response = await client.GetAsync("/weekplan/activity/999");

            Assert.Equal(HttpStatusCode.NotFound, response.StatusCode);
        }

        #endregion

        #region POST /weekplan/to-citizen/{citizenId:int} - Create activity for citizen

        [Fact]
        public async Task CreateActivityForCitizen_ReturnsCreated_WhenCitizenExists()
        {
            var factory = new GirafWebApplicationFactory(stubCoreClient: true);
            var seeder = new EmptyDb();
            var scope = factory.Services.CreateScope();
            factory.SeedDb(scope, seeder);
            var client = factory.CreateClient();
            client.AttachClaimsToken(role: "member");

            var newActivityDto = new CreateActivityDTO
            (
                Date: DateOnly.FromDateTime(DateTime.UtcNow),
                StartTime: TimeOnly.FromDateTime(DateTime.UtcNow),
                EndTime: TimeOnly.FromDateTime(DateTime.UtcNow.AddHours(1)),
                PictogramId: 1
            );

            var response = await client.PostAsJsonAsync("/weekplan/to-citizen/1", newActivityDto);

            response.EnsureSuccessStatusCode();
            Assert.Equal(HttpStatusCode.Created, response.StatusCode);
            var activityDto = await response.Content.ReadFromJsonAsync<ActivityDTO>();
            Assert.NotNull(activityDto);
            Assert.Equal(1, activityDto.PictogramId);
        }

        [Fact]
        public async Task CreateActivityForCitizen_ReturnsNotFound_WhenCitizenDoesNotExist()
        {
            var factory = new GirafWebApplicationFactory(stubCoreClient: true);
            var seeder = new EmptyDb();
            var scope = factory.Services.CreateScope();
            factory.SeedDb(scope, seeder);
            var client = factory.CreateClient();
            client.AttachClaimsToken(role: "member");

            var newActivityDto = new CreateActivityDTO
            (
                Date: DateOnly.FromDateTime(DateTime.UtcNow),
                StartTime: TimeOnly.FromDateTime(DateTime.UtcNow),
                EndTime: TimeOnly.FromDateTime(DateTime.UtcNow.AddHours(1)),
                PictogramId: null
            );

            // StubCoreClient returns NotFound for id >= 201
            var response = await client.PostAsJsonAsync("/weekplan/to-citizen/999", newActivityDto);

            Assert.Equal(HttpStatusCode.NotFound, response.StatusCode);
        }

        #endregion

        #region POST /weekplan/to-grade/{gradeId:int} - Create activity for grade

        [Fact]
        public async Task CreateActivityForGrade_ReturnsCreated_WhenGradeExists()
        {
            var factory = new GirafWebApplicationFactory(stubCoreClient: true);
            var seeder = new EmptyDb();
            var scope = factory.Services.CreateScope();
            factory.SeedDb(scope, seeder);
            var client = factory.CreateClient();
            client.AttachClaimsToken(role: "admin");

            var newActivityDto = new CreateActivityDTO
            (
                Date: DateOnly.FromDateTime(DateTime.UtcNow),
                StartTime: TimeOnly.FromDateTime(DateTime.UtcNow),
                EndTime: TimeOnly.FromDateTime(DateTime.UtcNow.AddHours(1)),
                PictogramId: 1
            );

            var response = await client.PostAsJsonAsync("/weekplan/to-grade/1", newActivityDto);

            response.EnsureSuccessStatusCode();
            Assert.Equal(HttpStatusCode.Created, response.StatusCode);
            var activityDto = await response.Content.ReadFromJsonAsync<ActivityDTO>();
            Assert.NotNull(activityDto);
        }

        [Fact]
        public async Task CreateActivityForGrade_ReturnsNotFound_WhenGradeDoesNotExist()
        {
            var factory = new GirafWebApplicationFactory(stubCoreClient: true);
            var seeder = new EmptyDb();
            var scope = factory.Services.CreateScope();
            factory.SeedDb(scope, seeder);
            var client = factory.CreateClient();
            client.AttachClaimsToken(role: "member");

            var newActivityDto = new CreateActivityDTO
            (
                Date: DateOnly.FromDateTime(DateTime.UtcNow),
                StartTime: TimeOnly.FromDateTime(DateTime.UtcNow),
                EndTime: TimeOnly.FromDateTime(DateTime.UtcNow.AddHours(1)),
                PictogramId: null
            );

            var response = await client.PostAsJsonAsync("/weekplan/to-grade/999", newActivityDto);

            Assert.Equal(HttpStatusCode.NotFound, response.StatusCode);
        }

        #endregion

        #region PUT /weekplan/activity/{id:int} - Update activity

        [Fact]
        public async Task UpdateActivity_ReturnsOk_WhenActivityExists()
        {
            var factory = new GirafWebApplicationFactory(stubCoreClient: true);
            var seeder = new BaseCaseDb();
            var scope = factory.Services.CreateScope();
            factory.SeedDb(scope, seeder);
            var client = factory.CreateClient();
            client.AttachClaimsToken(role: "member");

            int activityId = seeder.Activities[0].Id;

            var updateActivityDto = new UpdateActivityDTO
            (
                Date: DateOnly.FromDateTime(DateTime.UtcNow),
                StartTime: TimeOnly.FromDateTime(DateTime.UtcNow),
                EndTime: TimeOnly.FromDateTime(DateTime.UtcNow.AddHours(1)),
                IsCompleted: true,
                PictogramId: 1
            );

            var response = await client.PutAsJsonAsync($"/weekplan/activity/{activityId}", updateActivityDto);

            response.EnsureSuccessStatusCode();

            var returnedActivity = await response.Content.ReadFromJsonAsync<ActivityDTO>();
            Assert.NotNull(returnedActivity);
            Assert.Equal(activityId, returnedActivity.ActivityId);
            Assert.True(returnedActivity.IsCompleted);
            Assert.Equal(updateActivityDto.Date, returnedActivity.Date);
            Assert.Equal(updateActivityDto.StartTime, returnedActivity.StartTime);
            Assert.Equal(updateActivityDto.EndTime, returnedActivity.EndTime);
        }

        [Fact]
        public async Task UpdateActivity_ReturnsNotFound_WhenActivityDoesNotExist()
        {
            var factory = new GirafWebApplicationFactory(stubCoreClient: true);
            var seeder = new EmptyDb();
            var scope = factory.Services.CreateScope();
            factory.SeedDb(scope, seeder);
            var client = factory.CreateClient();
            client.AttachClaimsToken(role: "member");

            var updateDto = new UpdateActivityDTO
            (
                Date: DateOnly.FromDateTime(DateTime.UtcNow),
                StartTime: TimeOnly.FromDateTime(DateTime.UtcNow),
                EndTime: TimeOnly.FromDateTime(DateTime.UtcNow.AddHours(1)),
                IsCompleted: false,
                PictogramId: null
            );

            var response = await client.PutAsJsonAsync("/weekplan/activity/999", updateDto);

            Assert.Equal(HttpStatusCode.NotFound, response.StatusCode);
        }

        #endregion

        #region DELETE /weekplan/activity/{id:int} - Delete activity

        [Fact]
        public async Task DeleteActivity_ReturnsNoContent_WhenActivityExists()
        {
            var factory = new GirafWebApplicationFactory(stubCoreClient: true);
            var seeder = new BaseCaseDb();
            var scope = factory.Services.CreateScope();
            factory.SeedDb(scope, seeder);
            var client = factory.CreateClient();
            client.AttachClaimsToken(role: "member");

            int activityId = seeder.Activities[0].Id;
            var response = await client.DeleteAsync($"/weekplan/activity/{activityId}");

            Assert.Equal(HttpStatusCode.NoContent, response.StatusCode);

            using var verificationScope = factory.Services.CreateScope();
            var dbContext = verificationScope.ServiceProvider.GetRequiredService<GirafDbContext>();
            var deletedActivity = await dbContext.Activities.FindAsync(activityId);
            Assert.Null(deletedActivity);
        }

        [Fact]
        public async Task DeleteActivity_ReturnsNotFound_WhenActivityDoesNotExist()
        {
            var factory = new GirafWebApplicationFactory(stubCoreClient: true);
            var seeder = new EmptyDb();
            var scope = factory.Services.CreateScope();
            factory.SeedDb(scope, seeder);
            var client = factory.CreateClient();
            client.AttachClaimsToken(role: "member");

            var response = await client.DeleteAsync("/weekplan/activity/999");

            Assert.Equal(HttpStatusCode.NotFound, response.StatusCode);
        }

        #endregion

        #region PUT /weekplan/activity/{id:int}/iscomplete - Set activity completion status

        [Fact]
        public async Task SetActivityCompletionStatus_ReturnsOk_WhenActivityExists()
        {
            var factory = new GirafWebApplicationFactory(stubCoreClient: true);
            var seeder = new BaseCaseDb();
            var scope = factory.Services.CreateScope();
            factory.SeedDb(scope, seeder);
            var client = factory.CreateClient();
            client.AttachClaimsToken(role: "admin");

            int activityId = seeder.Activities[0].Id;

            var response = await client.PutAsync($"/weekplan/activity/{activityId}/iscomplete?IsComplete=true", null);

            response.EnsureSuccessStatusCode();

            using var verificationScope = factory.Services.CreateScope();
            var dbContext = verificationScope.ServiceProvider.GetRequiredService<GirafDbContext>();
            var updatedActivity = await dbContext.Activities.FindAsync(activityId);
            Assert.NotNull(updatedActivity);
            Assert.True(updatedActivity.IsCompleted);
        }

        [Fact]
        public async Task SetActivityCompletionStatus_ReturnsNotFound_WhenActivityDoesNotExist()
        {
            var factory = new GirafWebApplicationFactory(stubCoreClient: true);
            var seeder = new EmptyDb();
            var scope = factory.Services.CreateScope();
            factory.SeedDb(scope, seeder);
            var client = factory.CreateClient();
            client.AttachClaimsToken(role: "admin");

            var response = await client.PutAsync("/weekplan/activity/999/iscomplete?IsComplete=true", null);

            Assert.Equal(HttpStatusCode.NotFound, response.StatusCode);
        }

        #endregion

        #region POST /weekplan/activity/assign-pictogram/{activityId:int}/{pictogramId:int} - Assign pictogram

        [Fact]
        public async Task AssignPictogram_ReturnsOk_WhenActivityAndPictogramExist()
        {
            var factory = new GirafWebApplicationFactory(stubCoreClient: true);
            var seeder = new BaseCaseDb();
            var scope = factory.Services.CreateScope();
            factory.SeedDb(scope, seeder);
            var client = factory.CreateClient();
            client.AttachClaimsToken(role: "admin");

            int activityId = seeder.Activities[0].Id;

            var response = await client.PostAsync($"/weekplan/activity/assign-pictogram/{activityId}/5", null);

            response.EnsureSuccessStatusCode();
            var activityDto = await response.Content.ReadFromJsonAsync<ActivityDTO>();
            Assert.NotNull(activityDto);
            Assert.Equal(5, activityDto.PictogramId);
        }

        [Fact]
        public async Task AssignPictogram_ReturnsNotFound_WhenActivityDoesNotExist()
        {
            var factory = new GirafWebApplicationFactory(stubCoreClient: true);
            var seeder = new EmptyDb();
            var scope = factory.Services.CreateScope();
            factory.SeedDb(scope, seeder);
            var client = factory.CreateClient();
            client.AttachClaimsToken(role: "admin");

            var response = await client.PostAsync("/weekplan/activity/assign-pictogram/999/1", null);

            Assert.Equal(HttpStatusCode.NotFound, response.StatusCode);
        }

        [Fact]
        public async Task AssignPictogram_ReturnsNotFound_WhenPictogramDoesNotExist()
        {
            var factory = new GirafWebApplicationFactory(stubCoreClient: true);
            var seeder = new BaseCaseDb();
            var scope = factory.Services.CreateScope();
            factory.SeedDb(scope, seeder);
            var client = factory.CreateClient();
            client.AttachClaimsToken(role: "member");

            int activityId = seeder.Activities[0].Id;

            // StubCoreClient returns NotFound for id >= 201
            var response = await client.PostAsync($"/weekplan/activity/assign-pictogram/{activityId}/999", null);

            Assert.Equal(HttpStatusCode.NotFound, response.StatusCode);
        }

        #endregion

        #region Validation - Time and date input

        [Fact]
        public async Task CreateActivityForCitizen_ReturnsBadRequest_WhenEndTimeBeforeStartTime()
        {
            var factory = new GirafWebApplicationFactory(stubCoreClient: true);
            var seeder = new EmptyDb();
            var scope = factory.Services.CreateScope();
            factory.SeedDb(scope, seeder);
            var client = factory.CreateClient();
            client.AttachClaimsToken(role: "member");

            var newActivityDto = new CreateActivityDTO
            (
                Date: DateOnly.FromDateTime(DateTime.UtcNow),
                StartTime: new TimeOnly(10, 0),
                EndTime: new TimeOnly(8, 0),
                PictogramId: null
            );

            var response = await client.PostAsJsonAsync("/weekplan/to-citizen/1", newActivityDto);

            Assert.Equal(HttpStatusCode.BadRequest, response.StatusCode);
        }

        [Fact]
        public async Task CreateActivityForGrade_ReturnsBadRequest_WhenEndTimeBeforeStartTime()
        {
            var factory = new GirafWebApplicationFactory(stubCoreClient: true);
            var seeder = new EmptyDb();
            var scope = factory.Services.CreateScope();
            factory.SeedDb(scope, seeder);
            var client = factory.CreateClient();
            client.AttachClaimsToken(role: "admin");

            var newActivityDto = new CreateActivityDTO
            (
                Date: DateOnly.FromDateTime(DateTime.UtcNow),
                StartTime: new TimeOnly(10, 0),
                EndTime: new TimeOnly(8, 0),
                PictogramId: null
            );

            var response = await client.PostAsJsonAsync("/weekplan/to-grade/1", newActivityDto);

            Assert.Equal(HttpStatusCode.BadRequest, response.StatusCode);
        }

        [Fact]
        public async Task CreateActivityForCitizen_ReturnsBadRequest_WhenDateIsInvalid()
        {
            var factory = new GirafWebApplicationFactory(stubCoreClient: true);
            var seeder = new EmptyDb();
            var scope = factory.Services.CreateScope();
            factory.SeedDb(scope, seeder);
            var client = factory.CreateClient();
            client.AttachClaimsToken(role: "member");

            var content = new StringContent(
                """{"date":"not-a-date","startTime":"10:00:00","endTime":"11:00:00"}""",
                Encoding.UTF8, "application/json");

            var response = await client.PostAsync("/weekplan/to-citizen/1", content);

            Assert.Equal(HttpStatusCode.BadRequest, response.StatusCode);
        }

        [Fact]
        public async Task GetActivitiesForCitizenOnDate_ReturnsBadRequest_WhenDateIsInvalid()
        {
            var factory = new GirafWebApplicationFactory(stubCoreClient: true);
            var seeder = new EmptyDb();
            var scope = factory.Services.CreateScope();
            factory.SeedDb(scope, seeder);
            var client = factory.CreateClient();
            client.AttachClaimsToken(role: "member");

            var response = await client.GetAsync("/weekplan/1?date=not-a-date");

            Assert.Equal(HttpStatusCode.BadRequest, response.StatusCode);
        }

        [Fact]
        public async Task UpdateActivity_ReturnsBadRequest_WhenEndTimeBeforeStartTime()
        {
            var factory = new GirafWebApplicationFactory(stubCoreClient: true);
            var seeder = new BaseCaseDb();
            var scope = factory.Services.CreateScope();
            factory.SeedDb(scope, seeder);
            var client = factory.CreateClient();
            client.AttachClaimsToken(role: "member");

            int activityId = seeder.Activities[0].Id;

            var updateDto = new UpdateActivityDTO
            (
                Date: DateOnly.FromDateTime(DateTime.UtcNow),
                StartTime: new TimeOnly(14, 0),
                EndTime: new TimeOnly(12, 0),
                IsCompleted: false,
                PictogramId: null
            );

            var response = await client.PutAsJsonAsync($"/weekplan/activity/{activityId}", updateDto);

            Assert.Equal(HttpStatusCode.BadRequest, response.StatusCode);
        }

        #endregion

        #region POST /weekplan/activity/copy-citizen/{citizenId:int} - Copy activities for citizen

        [Fact]
        public async Task CopyActivityForCitizen_ReturnsOk_WhenActivitiesExist()
        {
            var factory = new GirafWebApplicationFactory(stubCoreClient: true);
            var seeder = new BaseCaseDb();
            var scope = factory.Services.CreateScope();
            factory.SeedDb(scope, seeder);
            var client = factory.CreateClient();
            client.AttachClaimsToken(role: "member");

            var sourceDate = DateOnly.FromDateTime(DateTime.UtcNow).ToString("yyyy-MM-dd");
            var targetDate = DateOnly.FromDateTime(DateTime.UtcNow.AddDays(1)).ToString("yyyy-MM-dd");
            var activityIds = new List<int> { seeder.Activities[0].Id };

            var response = await client.PostAsJsonAsync(
                $"/weekplan/activity/copy-citizen/1?sourceDate={sourceDate}&targetDate={targetDate}",
                activityIds);

            response.EnsureSuccessStatusCode();

            using var verifyScope = factory.Services.CreateScope();
            var dbContext = verifyScope.ServiceProvider.GetRequiredService<GirafDbContext>();
            var copiedActivities = dbContext.Activities
                .Where(a => a.CitizenId == 1 && a.Date == DateOnly.FromDateTime(DateTime.UtcNow.AddDays(1)))
                .ToList();
            Assert.NotEmpty(copiedActivities);
        }

        [Fact]
        public async Task CopyActivityForCitizen_ReturnsNotFound_WhenNoActivitiesExist()
        {
            var factory = new GirafWebApplicationFactory(stubCoreClient: true);
            var seeder = new EmptyDb();
            var scope = factory.Services.CreateScope();
            factory.SeedDb(scope, seeder);
            var client = factory.CreateClient();
            client.AttachClaimsToken(role: "member");

            var sourceDate = DateOnly.FromDateTime(DateTime.UtcNow).ToString("yyyy-MM-dd");
            var targetDate = DateOnly.FromDateTime(DateTime.UtcNow.AddDays(1)).ToString("yyyy-MM-dd");
            var activityIds = new List<int>();

            var response = await client.PostAsJsonAsync(
                $"/weekplan/activity/copy-citizen/1?sourceDate={sourceDate}&targetDate={targetDate}",
                activityIds);

            Assert.Equal(HttpStatusCode.NotFound, response.StatusCode);
        }

        #endregion

        #region POST /weekplan/activity/copy-grade/{gradeId:int} - Copy activities for grade

        [Fact]
        public async Task CopyActivityForGrade_ReturnsOk_WhenActivitiesExist()
        {
            var factory = new GirafWebApplicationFactory(stubCoreClient: true);
            var seeder = new BaseCaseDb();
            var scope = factory.Services.CreateScope();
            factory.SeedDb(scope, seeder);
            var client = factory.CreateClient();
            client.AttachClaimsToken(role: "admin");

            var sourceDate = DateOnly.FromDateTime(DateTime.UtcNow).ToString("yyyy-MM-dd");
            var targetDate = DateOnly.FromDateTime(DateTime.UtcNow.AddDays(1)).ToString("yyyy-MM-dd");
            var activityIds = new List<int> { seeder.Activities[1].Id };

            var response = await client.PostAsJsonAsync(
                $"/weekplan/activity/copy-grade/1?sourceDate={sourceDate}&targetDate={targetDate}",
                activityIds);

            response.EnsureSuccessStatusCode();

            using var verifyScope = factory.Services.CreateScope();
            var dbContext = verifyScope.ServiceProvider.GetRequiredService<GirafDbContext>();
            var copiedActivities = dbContext.Activities
                .Where(a => a.GradeId == 1 && a.Date == DateOnly.FromDateTime(DateTime.UtcNow.AddDays(1)))
                .ToList();
            Assert.NotEmpty(copiedActivities);
        }

        [Fact]
        public async Task CopyActivityForGrade_ReturnsNotFound_WhenNoActivitiesExist()
        {
            var factory = new GirafWebApplicationFactory(stubCoreClient: true);
            var seeder = new EmptyDb();
            var scope = factory.Services.CreateScope();
            factory.SeedDb(scope, seeder);
            var client = factory.CreateClient();
            client.AttachClaimsToken(role: "admin");

            var sourceDate = DateOnly.FromDateTime(DateTime.UtcNow).ToString("yyyy-MM-dd");
            var targetDate = DateOnly.FromDateTime(DateTime.UtcNow.AddDays(1)).ToString("yyyy-MM-dd");
            var activityIds = new List<int>();

            var response = await client.PostAsJsonAsync(
                $"/weekplan/activity/copy-grade/1?sourceDate={sourceDate}&targetDate={targetDate}",
                activityIds);

            Assert.Equal(HttpStatusCode.NotFound, response.StatusCode);
        }

        #endregion

        #region Authentication - Unauthenticated requests

        [Fact]
        public async Task CreateActivityForCitizen_ReturnsUnauthorized_WhenNoToken()
        {
            var factory = new GirafWebApplicationFactory(stubCoreClient: true);
            var seeder = new EmptyDb();
            var scope = factory.Services.CreateScope();
            factory.SeedDb(scope, seeder);
            var client = factory.CreateClient();

            var newActivityDto = new CreateActivityDTO
            (
                Date: DateOnly.FromDateTime(DateTime.UtcNow),
                StartTime: new TimeOnly(10, 0),
                EndTime: new TimeOnly(11, 0),
                PictogramId: null
            );

            var response = await client.PostAsJsonAsync("/weekplan/to-citizen/1", newActivityDto);

            Assert.Equal(HttpStatusCode.Unauthorized, response.StatusCode);
        }

        [Fact]
        public async Task DeleteActivity_ReturnsUnauthorized_WhenNoToken()
        {
            var factory = new GirafWebApplicationFactory(stubCoreClient: true);
            var seeder = new BaseCaseDb();
            var scope = factory.Services.CreateScope();
            factory.SeedDb(scope, seeder);
            var client = factory.CreateClient();

            int activityId = seeder.Activities[0].Id;
            var response = await client.DeleteAsync($"/weekplan/activity/{activityId}");

            Assert.Equal(HttpStatusCode.Unauthorized, response.StatusCode);
        }

        #endregion

        #region Authorization - Ownership checks (Forbidden owner returns 403)

        [Fact]
        public async Task GetActivitiesForCitizen_ReturnsForbidden_WhenOwnerForbidden()
        {
            var factory = new GirafWebApplicationFactory(stubCoreClient: true);
            var seeder = new EmptyDb();
            var scope = factory.Services.CreateScope();
            factory.SeedDb(scope, seeder);
            var client = factory.CreateClient();
            client.AttachClaimsToken(role: "member");

            var date = DateTime.UtcNow.Date.ToString("yyyy-MM-dd");
            var response = await client.GetAsync($"/weekplan/101?date={date}");

            Assert.Equal(HttpStatusCode.Forbidden, response.StatusCode);
        }

        [Fact]
        public async Task GetActivitiesForGrade_ReturnsForbidden_WhenOwnerForbidden()
        {
            var factory = new GirafWebApplicationFactory(stubCoreClient: true);
            var seeder = new EmptyDb();
            var scope = factory.Services.CreateScope();
            factory.SeedDb(scope, seeder);
            var client = factory.CreateClient();
            client.AttachClaimsToken(role: "member");

            var date = DateTime.UtcNow.Date.ToString("yyyy-MM-dd");
            var response = await client.GetAsync($"/weekplan/grade/101?date={date}");

            Assert.Equal(HttpStatusCode.Forbidden, response.StatusCode);
        }

        [Fact]
        public async Task GetActivityById_ReturnsForbidden_WhenOwnerForbidden()
        {
            var factory = new GirafWebApplicationFactory(stubCoreClient: true);
            var seeder = new ForbiddenOwnerDb();
            var scope = factory.Services.CreateScope();
            factory.SeedDb(scope, seeder);
            var client = factory.CreateClient();
            client.AttachClaimsToken(role: "member");

            int activityId = seeder.Activities[0].Id;
            var response = await client.GetAsync($"/weekplan/activity/{activityId}");

            Assert.Equal(HttpStatusCode.Forbidden, response.StatusCode);
        }

        [Fact]
        public async Task ToggleActivityStatus_ReturnsForbidden_WhenOwnerForbidden()
        {
            var factory = new GirafWebApplicationFactory(stubCoreClient: true);
            var seeder = new ForbiddenOwnerDb();
            var scope = factory.Services.CreateScope();
            factory.SeedDb(scope, seeder);
            var client = factory.CreateClient();
            client.AttachClaimsToken(role: "member");

            int activityId = seeder.Activities[0].Id;
            var response = await client.PutAsync($"/weekplan/activity/{activityId}/iscomplete?IsComplete=true", null);

            Assert.Equal(HttpStatusCode.Forbidden, response.StatusCode);
        }

        [Fact]
        public async Task DeleteActivity_ReturnsForbidden_WhenOwnerForbidden()
        {
            var factory = new GirafWebApplicationFactory(stubCoreClient: true);
            var seeder = new ForbiddenOwnerDb();
            var scope = factory.Services.CreateScope();
            factory.SeedDb(scope, seeder);
            var client = factory.CreateClient();
            client.AttachClaimsToken(role: "member");

            int activityId = seeder.Activities[0].Id;
            var response = await client.DeleteAsync($"/weekplan/activity/{activityId}");

            Assert.Equal(HttpStatusCode.Forbidden, response.StatusCode);
        }

        [Fact]
        public async Task UpdateActivity_ReturnsForbidden_WhenOwnerForbidden()
        {
            var factory = new GirafWebApplicationFactory(stubCoreClient: true);
            var seeder = new ForbiddenOwnerDb();
            var scope = factory.Services.CreateScope();
            factory.SeedDb(scope, seeder);
            var client = factory.CreateClient();
            client.AttachClaimsToken(role: "member");

            int activityId = seeder.Activities[0].Id;
            var updateDto = new UpdateActivityDTO
            (
                Date: DateOnly.FromDateTime(DateTime.UtcNow),
                StartTime: new TimeOnly(9, 0),
                EndTime: new TimeOnly(10, 0),
                IsCompleted: false,
                PictogramId: null
            );

            var response = await client.PutAsJsonAsync($"/weekplan/activity/{activityId}", updateDto);

            Assert.Equal(HttpStatusCode.Forbidden, response.StatusCode);
        }

        [Fact]
        public async Task AssignPictogram_ReturnsForbidden_WhenOwnerForbidden()
        {
            var factory = new GirafWebApplicationFactory(stubCoreClient: true);
            var seeder = new ForbiddenOwnerDb();
            var scope = factory.Services.CreateScope();
            factory.SeedDb(scope, seeder);
            var client = factory.CreateClient();
            client.AttachClaimsToken(role: "member");

            int activityId = seeder.Activities[0].Id;
            var response = await client.PostAsync($"/weekplan/activity/assign-pictogram/{activityId}/1", null);

            Assert.Equal(HttpStatusCode.Forbidden, response.StatusCode);
        }

        [Fact]
        public async Task CopyActivityForCitizen_ReturnsForbidden_WhenOwnerForbidden()
        {
            var factory = new GirafWebApplicationFactory(stubCoreClient: true);
            var seeder = new EmptyDb();
            var scope = factory.Services.CreateScope();
            factory.SeedDb(scope, seeder);
            var client = factory.CreateClient();
            client.AttachClaimsToken(role: "member");

            var sourceDate = DateOnly.FromDateTime(DateTime.UtcNow).ToString("yyyy-MM-dd");
            var targetDate = DateOnly.FromDateTime(DateTime.UtcNow.AddDays(1)).ToString("yyyy-MM-dd");
            var activityIds = new List<int>();

            var response = await client.PostAsJsonAsync(
                $"/weekplan/activity/copy-citizen/101?sourceDate={sourceDate}&targetDate={targetDate}",
                activityIds);

            Assert.Equal(HttpStatusCode.Forbidden, response.StatusCode);
        }

        [Fact]
        public async Task CopyActivityForGrade_ReturnsForbidden_WhenOwnerForbidden()
        {
            var factory = new GirafWebApplicationFactory(stubCoreClient: true);
            var seeder = new EmptyDb();
            var scope = factory.Services.CreateScope();
            factory.SeedDb(scope, seeder);
            var client = factory.CreateClient();
            client.AttachClaimsToken(role: "member");

            var sourceDate = DateOnly.FromDateTime(DateTime.UtcNow).ToString("yyyy-MM-dd");
            var targetDate = DateOnly.FromDateTime(DateTime.UtcNow.AddDays(1)).ToString("yyyy-MM-dd");
            var activityIds = new List<int>();

            var response = await client.PostAsJsonAsync(
                $"/weekplan/activity/copy-grade/101?sourceDate={sourceDate}&targetDate={targetDate}",
                activityIds);

            Assert.Equal(HttpStatusCode.Forbidden, response.StatusCode);
        }

        #endregion

        #region Authorization - Orphaned activities (fail closed)

        [Fact]
        public async Task GetActivityById_ReturnsForbidden_WhenActivityHasNoOwner()
        {
            var factory = new GirafWebApplicationFactory(stubCoreClient: true);
            var seeder = new OrphanedActivityDb();
            var scope = factory.Services.CreateScope();
            factory.SeedDb(scope, seeder);
            var client = factory.CreateClient();
            client.AttachClaimsToken(role: "admin");

            int activityId = seeder.Activities[0].Id;
            var response = await client.GetAsync($"/weekplan/activity/{activityId}");

            Assert.Equal(HttpStatusCode.Forbidden, response.StatusCode);
        }

        [Fact]
        public async Task UpdateActivity_ReturnsForbidden_WhenActivityHasNoOwner()
        {
            var factory = new GirafWebApplicationFactory(stubCoreClient: true);
            var seeder = new OrphanedActivityDb();
            var scope = factory.Services.CreateScope();
            factory.SeedDb(scope, seeder);
            var client = factory.CreateClient();
            client.AttachClaimsToken(role: "admin");

            int activityId = seeder.Activities[0].Id;
            var updateDto = new UpdateActivityDTO
            (
                Date: DateOnly.FromDateTime(DateTime.UtcNow),
                StartTime: new TimeOnly(9, 0),
                EndTime: new TimeOnly(10, 0),
                IsCompleted: false,
                PictogramId: null
            );

            var response = await client.PutAsJsonAsync($"/weekplan/activity/{activityId}", updateDto);

            Assert.Equal(HttpStatusCode.Forbidden, response.StatusCode);
        }

        [Fact]
        public async Task DeleteActivity_ReturnsForbidden_WhenActivityHasNoOwner()
        {
            var factory = new GirafWebApplicationFactory(stubCoreClient: true);
            var seeder = new OrphanedActivityDb();
            var scope = factory.Services.CreateScope();
            factory.SeedDb(scope, seeder);
            var client = factory.CreateClient();
            client.AttachClaimsToken(role: "admin");

            int activityId = seeder.Activities[0].Id;
            var response = await client.DeleteAsync($"/weekplan/activity/{activityId}");

            Assert.Equal(HttpStatusCode.Forbidden, response.StatusCode);
        }

        #endregion
    }
}
