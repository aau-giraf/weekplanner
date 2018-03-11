using IO.Swagger.Api;
using IO.Swagger.Model;
using System;
using System.Collections.Generic;
using System.Text;
using Xunit;

namespace WeekPlanner.Tests
{
    public class IntegrationServiceTests
    {
        [Fact]
        public async void Integration_SendLoginRequest_CorrectLogin()
        {
            // Arrange
            var service = new CloudDataStore();
            
            // Act
            var result = await service.SendLoginRequest("Graatand", "password");
            
            // Assert
            Assert.True(result.Data.Username == "Graatand");
        }

        [Fact]
        public async void Integration_Swagger_CorrectLogin()
        {
            // Arrange
            var api = new AccountApi();
            var basePath = "http://localhost:5000";
            api.Configuration.ApiClient = new IO.Swagger.Client.ApiClient(basePath);
            
            // Act
            var result = await api.V1AccountLoginPostAsync(
                new LoginDTO("Graatand", "password")
                );
            
            // Assert
            Assert.True(result.Data.Username == "Graatand");
        }
        
        [Theory]
        [InlineData("13uej912389u", "adw89u129363")]
        [InlineData("00000", "222222")]
        [InlineData("asd", "s$$$$")]
        public async void Integration_Swagger_BadLogin(string username, string password)
        {
            // Arrange
            var api = new AccountApi();
            var basePath = "http://localhost:5000";
            api.Configuration.ApiClient = new IO.Swagger.Client.ApiClient(basePath);
            
            // Act
            var result = await api.V1AccountLoginPostAsync(
                new LoginDTO(username, password)
                );

            // Assert
            Assert.True(result.ErrorKey.ToString() == Response.ErrorKeyEnum.InvalidCredentials.ToString());
        }

        [Fact]
        public async void Integration_Swagger_ServerDown() {
            // Arrange
            var api = new AccountApi();
            var basePath = "awudihawduu";
            api.Configuration.ApiClient = new IO.Swagger.Client.ApiClient(basePath);

            // Act
            var result = await api.V1AccountLoginPostAsync(
                new LoginDTO("username", "password")
                );

        }
               
    }
}
