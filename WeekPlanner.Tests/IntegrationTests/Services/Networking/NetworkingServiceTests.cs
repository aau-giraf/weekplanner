using AutoFixture;
using AutoFixture.AutoMoq;
using Xunit;

namespace WeekPlanner.Tests.IntegrationTests.Services.Networking
{
    public class NetworkingServiceTests
    {
        private readonly IFixture _fixture;

        public NetworkingServiceTests()
        {
            _fixture = new Fixture().Customize(new AutoMoqCustomization());
        }

        // Use the naming convention MethodName_StateUnderTest_ExpectedBehavior

        /*[Theory]
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
        }*/
    }
}
