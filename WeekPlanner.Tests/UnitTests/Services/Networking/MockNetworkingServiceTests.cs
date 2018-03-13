using WeekPlanner.Services.Networking;
using Xunit;

namespace WeekPlanner.Tests.UnitTests.Services.Networking
{
    public class MockNetworkingServiceTests
    {
        // Use the naming convention MethodName_StateUnderTest_ExpectedBehavior

        [Fact]
        public async void SendLoginRequest_ValidCredentials_UserData()
        {
            // Arrange
            var service = new MockNetworkingService();

            // Act
            var result = await service.SendLoginRequest("Graatand", "password");

            // Assert
            Assert.True(result.Data.Username == "Graatand");
        }
        
        // TODO: SendLoginRequest_BadLogin
        // TODO: SendLoginRequest_ServerDown
    }
}
