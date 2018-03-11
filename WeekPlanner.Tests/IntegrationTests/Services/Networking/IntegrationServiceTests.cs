using IO.Swagger.Api;
using IO.Swagger.Model;
using System;
using System.Collections.Generic;
using System.Text;
using WeekPlanner.Services.Networking;
using Xunit;
using AutoFixture;
using AutoFixture.AutoMoq;

namespace WeekPlanner.Tests
{
    public class IntegrationServiceTests
    {
        private readonly IFixture _fixture;

        public IntegrationServiceTests()
        {
            _fixture = new Fixture().Customize(new AutoMoqCustomization());
        }

        // Use the naming convention MethodName_StateUnderTest_ExpectedBehavior

        [Theory]
        [InlineData("Graatand", "password")]
        [InlineData("Kurt", "password")]
        public async void SendLoginRequest_ValidCredentials_UserData(string username, string password)
        {
            // Arrange
            var service = _fixture.Create<NetworkingService>();

            // Act
            var result = await service.SendLoginRequest(username, password);
            
            // Assert
            Assert.True(result.Data.Username == username);
        }
    }
}
