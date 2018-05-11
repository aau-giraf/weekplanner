using System;
using AutoFixture;
using IO.Swagger.Api;
using Moq;
using WeekPlanner.Services.Settings;
using WeekPlanner.Tests.UnitTests.Base;
using Xunit;

namespace WeekPlanner.Tests.UnitTests.Services.Settings
{
    public class SettingsServiceTests : TestsBase
    {
        [Fact]
        public void UseTokenFor_ValidCitizenTokenAlreadySet_AddsApiKeyToConfiguration()
        {
            // Arrange
            var token = "ValidCitizenToken";
            var accountApiMock = Fixture.Freeze<Mock<IAccountApi>>();
            var sut = Fixture.Build<SettingsService>()
                .With(s => s.CitizenAuthToken, token)
                .Create();

            // Act
            sut.UseTokenFor(UserType.Citizen);
            
            // Assert
            Assert.Equal($"bearer {token}", accountApiMock.Object.Configuration.ApiKey["Authorization"]);
        }
        
        [Fact]
        public void UseTokenFor_ValidDepartmentTokenAlreadySet_AddsApiKeyToConfiguration()
        {
            // Arrange
            var token = "ValidDepartmentToken";
            var accountApiMock = Fixture.Freeze<Mock<IAccountApi>>();
            var sut = Fixture.Build<SettingsService>()
                .With(s => s.AuthToken, token)
                .Create();

            // Act
            sut.UseTokenFor(UserType.Guardian);
            
            // Assert
            Assert.Equal($"bearer {token}", accountApiMock.Object.Configuration.ApiKey["Authorization"]);
        }

        [Theory]
        [InlineData("")]
        [InlineData(null)]
        public void UseTokenFor_CitizenAndNullOrEmptyToken_ThrowsArgumentException(string token)
        {
            // Arrange
            var sut = Fixture.Build<SettingsService>()
                .With(s => s.CitizenAuthToken, token)
                .Create();
            
            // Assert & Act
            Assert.Throws<ArgumentException>(() => sut.UseTokenFor(UserType.Citizen));
        }
        
        [Theory]
        [InlineData("")]
        [InlineData(null)]
        public void UseTokenFor_DepartmentAndNullOrEmptyToken_ThrowsArgumentException(string token)
        {
            // Arrange
            var sut = Fixture.Build<SettingsService>()
                .With(s => s.AuthToken, token)
                .Create();
            
            // Assert & Act
            Assert.Throws<ArgumentException>(() => sut.UseTokenFor(UserType.Guardian));
        }
        
    }
}