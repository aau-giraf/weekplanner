using System;
using System.Threading.Tasks;
using AutoFixture;
using AutoFixture.AutoMoq;
using IO.Swagger.Api;
using IO.Swagger.Client;
using IO.Swagger.Model;
using Moq;
using WeekPlanner.Services;
using WeekPlanner.Tests.UnitTests.Base;
using WeekPlanner.Services.Login;
using WeekPlanner.Services.Request;
using WeekPlanner.Services.Settings;
using WeekPlanner.ViewModels.Base;
using Xamarin.Forms;
using Xunit;

namespace WeekPlanner.Tests.UnitTests.Services.Login
{
    public class LoginServiceTests : TestsBase
    {
        [Theory]
        [InlineData(null)]
        [InlineData("")]
        public async void LoginAndThenAsync_UserTypeDepartmentAndEmptyOrNullPassword_ThrowsArgumentException(string password)
        {
            // Arrange
            var sut = Fixture.Create<LoginService>();
            const UserType userType = UserType.Guardian;
            const string username = "NotEmpty";
            var onSuccess = Fixture.Create<Func<Task>>();
            
            // Assert       Act
            await Assert.ThrowsAsync<ArgumentException>(async () => await sut.LoginAndThenAsync(userType, username, password, onSuccess));
        }

        [Theory]
        [InlineData(UserType.Guardian, "NotEmpty", "NotEmpty")]
        [InlineData(UserType.Citizen, "NotEmpty", "")]
        public async void LoginAndThenAsync_ValidInput_InvokesV1AccountLoginPostAsync(UserType userType, string username,
            string password)
        {
            // Arrange
            FreezeMockOfIRequestService<ResponseString>();
            
            var accountApiMock = Fixture.Freeze<Mock<IAccountApi>>();
            accountApiMock.Setup(a => a.V1AccountLoginPostAsync(It.IsAny<LoginDTO>()))
                .ReturnsUsingFixture(Fixture);
            var sut = Fixture.Create<LoginService>();
            var onSuccess = Fixture.Create<Func<Task>>();
            
            // Act
            await sut.LoginAndThenAsync(userType, username, password, onSuccess);

            // Assert
            accountApiMock.Verify(a => a.V1AccountLoginPostAsync(It.IsAny<LoginDTO>()));
        }

        [Fact]
        public async void LoginAndThenAsync_UserTypeDepartmentAndSuccessResponse_SetsGuardianAuthToken()
        {
            // Arrange
            const string token = "GuardianAuthToken";
            var (settingsServiceMock, sut) = SetupLoginServiceWithMocks(token);
            
            // Act
            await sut.LoginAndThenAsync(UserType.Guardian, "NotEmpty", "NotEmpty", Fixture.Create<Func<Task>>());
            
            // Assert
            settingsServiceMock.VerifySet(s => s.AuthToken = token);
        }
        
        [Fact]
        public async void LoginAndThenAsync_UserTypeCitizenAndSuccessResponse_SetCitizenAuthToken()
        {
            // Arrange
            const string token = "CitizenToken";
            var (settingsServiceMock, sut) = SetupLoginServiceWithMocks(token);

            // Act
            await sut.LoginAndThenAsync(UserType.Citizen, "NotEmpty", "NotEmpty", Fixture.Create<Func<Task>>());
            
            // Assert
            settingsServiceMock.VerifySet(s => s.AuthToken = token);
        }

        private (Mock<ISettingsService> settingsServiceMock, LoginService sut) SetupLoginServiceWithMocks(string token)
        {
            var settingsServiceMock = Fixture.Freeze<Mock<ISettingsService>>();

            var response = Fixture.Build<ResponseString>()
                .With(r => r.Success, true)
                .With(r => r.Data, token)
                .With(r => r.ErrorKey, ResponseString.ErrorKeyEnum.NoError)
                .Create();
            FreezeMockOfIRequestService<ResponseString>();
            Fixture.Freeze<Mock<IAccountApi>>()
                .Setup(a => a.V1AccountLoginPostAsync(It.IsAny<LoginDTO>()))
                .ReturnsAsync(response);

            var sut = Fixture.Create<LoginService>();
            return (settingsServiceMock, sut);
        }

        [Fact]
        public async void LoginAndThenAsync_SuccessfulResponse_InvokesOnSucces()
        {
            // Arrange
            var response = Fixture.Build<ResponseString>()
                .With(r => r.Success, true)
                .With(r => r.ErrorKey, ResponseString.ErrorKeyEnum.NoError)
                .Create();
            
            FreezeMockOfIRequestService<ResponseString>();

            var onSuccessInvoked = false;
            Func<Task> onSuccess = async () => { onSuccessInvoked = true; };
            
            Fixture.Freeze<Mock<IAccountApi>>()
                .Setup(a => a.V1AccountLoginPostAsync(It.IsAny<LoginDTO>()))
                .ReturnsAsync(response);

            var sut = Fixture.Create<LoginService>();
            
            // Act
            await sut.LoginAndThenAsync(UserType.Citizen, "NotEmpty", "NotEmpty", onSuccess);
            
            // Assert
            Assert.True(onSuccessInvoked);
        }

        private Mock<IDialogService> FreezeDialogServiceMock()
        {
            var dialogServiceMock = Fixture.Create<Mock<IDialogService>>();
            dialogServiceMock.Setup(ds => ds.ShowAlertAsync(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>()));
            return dialogServiceMock;
        }

        private void DialogServiceMock_Verify_ShowAlert_CalledOnce(Mock<IDialogService> dialogServiceMock)
        {
            dialogServiceMock.Verify(
                d => d.ShowAlertAsync(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>()), Times.Once);
        }
        
    }
}