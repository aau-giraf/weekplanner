using IO.Swagger.Api;
using IO.Swagger.Model;
using System;
using Xunit;

namespace WeekPlanner.Tests
{
    public class ServiceTests
    {
        

        [Fact]
        public async void SendLoginRequest_CorrectLogin()
        {
            // Arrange
            var service = new MockDataStore();

            // Act
            var result = await service.SendLoginRequest("Graatand", "password");

            // Assert
            Assert.True(result.Data.Username == "Graatand");
        }
        
        // TODO: SendLoginRequest_BadLogin
        // TODO: SendLoginRequest_ServerDown
    }
}
