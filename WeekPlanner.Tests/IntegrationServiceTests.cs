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
            var service = new CloudDataStore();
            var result = await service.SendLoginRequest("Graatand", "password");
            Assert.True(result.Data.Username == "Graatand");
        }

        [Fact]
        public async void Integration_SendLoginRequest_ServerDown()
        {
            var service = new CloudDataStore();
            var result = await service.SendLoginRequest("Graatand", "password");
            Assert.True(result.Data.Username == "Graatand");
        }

        [Fact]
        public async void Integration_Swagger_CorrectLogin()
        {
            var api = new AccountApi();
            var basePath = "http://localhost:5000";
            api.Configuration.ApiClient = new IO.Swagger.Client.ApiClient(basePath);
            var user = await api.V1AccountLoginPostAsync(
                new LoginDTO("Graatand", "password")
                );
            Assert.True(user.Data.Username == "Graatand");
        }
        [Fact]
        public async void Integration_Swagger_BadLogin()
        {
            var api = new AccountApi();
            var basePath = "http://localhost:5000";
            api.Configuration.ApiClient = new IO.Swagger.Client.ApiClient(basePath);
            var user = await api.V1AccountLoginPostAsync(
                new LoginDTO("13uej912389u", "adw89u129363")
                );
        }
    }
}
