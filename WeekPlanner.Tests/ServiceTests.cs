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
            var service = new MockDataStore();
            var result = await service.SendLoginRequest("Graatand", "password");
            Assert.True(result.Data.Username == "Graatand");
        }

        // TODO: SendLoginRequest_BadLogin
        // TODO: SendLoginRequest_ServerDown
    }
}
