
using IO.Swagger.Api;
using IO.Swagger.Client;
using IO.Swagger.Model;
using Xunit;

namespace WeekPlanner.Tests.IntegrationTests.Swagger.IO.Api
{
   /* public class AccountApiTests

    {
        
        [Theory]
        [InlineData("Graatand", "password")]
        public async void V1AccountLoginPostAsync_ValidCredentials_UserData(string username, string password)
        {
            // Arrange
            var api = new AccountApi();
            var basePath = "http://localhost:5000";
            api.Configuration.ApiClient = new ApiClient(basePath);

            // Act
            var result = await api.V1AccountLoginPostAsync(
                new LoginDTO(username, password)
                );

            // Assert
            Assert.True(result.Data.Username == "Graatand");
        }

        [Theory]
        [InlineData("13uej912389u", "adw89u129363")]
        [InlineData("00000", "222222")]
        [InlineData("asd", "s$$$$")]
        public async void V1AccountLoginPostAsync_InvalidCredentials_Error(string username, string password)
        {
            // Arrange
            var api = new AccountApi();
            var basePath = "http://localhost:5000";
            api.Configuration.ApiClient = new ApiClient(basePath);

            // Act
            var result = await api.V1AccountLoginPostAsync(
                new LoginDTO(username, password)
                );

            // Assert
            Assert.True(result.ErrorKey.ToString() == Response.ErrorKeyEnum.InvalidCredentials.ToString());
        }

        [Fact]
        public async void V1AccountLoginPostAsync_ServerDown_404()
        {
            // Arrange
            var api = new AccountApi();
            var basePath = "http://awudihawduu.comasdmasd:5000";
            api.Configuration.ApiClient = new ApiClient(basePath);

            // Act and Assert
            await Assert.ThrowsAsync<ApiException>(async () => await api.V1AccountLoginPostAsync(
                 new LoginDTO("Graatand", "password")
             ));
        }
    }*/

