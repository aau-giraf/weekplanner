
using IO.Swagger.Api;
using IO.Swagger.Client;
using IO.Swagger.Model;
using Xunit;

namespace WeekPlanner.Tests.IntegrationTests.Swagger.IO.Api
{
    public class AccountApiTests
    {
        [Theory]
        [InlineData("Graatand", "password")]
        public async void V1AccountLoginPostAsync_ValidCredentials_UserData(string username, string password)
        {
            // Arrange
            var api = new AccountApi();
            var basePath = "http://web.giraf.cs.aau.dk:5050";
            api.Configuration.ApiClient = new ApiClient(basePath);

            // Act
            var result = await api.V1AccountLoginPostAsync(
                new LoginDTO(username, password)
                );

            // Assert
            Assert.True(result.Data.Username == "Graatand");
        }


        /*  Test if the login in page returns the correct error when the user sends a login request
            Each InlineData is a test with the specified data as test data, run seperately 
            the test also contain supposedly test for simple SQL injection in the entries */
        [Theory]
        [InlineData("13uej912389u", "adw89u129363")]
        [InlineData("00000", "222222")]
        [InlineData("asd", "s$$$$")]
        [InlineData("' or 1=1", "password=1")]
        [InlineData("SELECT * FROM Users WHERE User_Name = ‘Graatand’","")]
        [InlineData("SELECT * FROM Users WHERE User_Name = ‘Graatand’", "SELCT * FROM Users WHERE Password = 'password'")]
        [InlineData("", "SELCT * FROM Users WHERE Password = 'password'")]
        public async void V1AccountLoginPostAsync_InvalidCredentials_Error(string username, string password)
        {
            // Arrange
            var api = new AccountApi();
            var basePath = "http://web.giraf.cs.aau.dk:5050";
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
            var basePath = "http://ThisIsAnUnreachableLocation.WhichShouldEnsureExceptionThrow:5000";
            api.Configuration.ApiClient = new ApiClient(basePath);

            // Act and Assert
            await Assert.ThrowsAsync<ApiException>(async () => await api.V1AccountLoginPostAsync(
                 new LoginDTO("Graatand", "password")
             ));
        }
    }
}
