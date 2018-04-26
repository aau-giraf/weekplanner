using System;
using System.Threading.Tasks;
using AutoFixture;
using AutoFixture.AutoMoq;
using IO.Swagger.Api;
using IO.Swagger.Client;
using IO.Swagger.Model;
using Moq;
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
            var userType = UserType.Guardian;
            var username = "NotEmpty";
            var onSuccess = Fixture.Create<Func<Task>>();
            
            // Assert       Act
            await Assert.ThrowsAsync<ArgumentException>(async () => await sut.LoginAndThenAsync(onSuccess, userType, username, password));
        }

        [Theory]
        [InlineData(UserType.Guardian, "NotEmpty", "NotEmpty")]
        [InlineData(UserType.Citizen, "NotEmpty", "")]
        public async void LoginAndThenAsync_ValidInput_InvokesV1AccountLoginPostAsync(UserType userType, string username,
            string password)
        {
            // Arrange
            async Task SendRequestAndThenAsyncMock<TS, TR>(TS sender, Func<Task<TR>> requestAsync, Func<TR, Task> onSuccessAsync,
                Func<Task> onExceptionAsync = null,
                Func<Task> onRequestFailedAsync = null,
                string exceptionErrorMessageKey = MessageKeys.RequestFailed,
                string requestFailedMessageKey = MessageKeys.RequestFailed) where TS : class
            {
                await requestAsync.Invoke();
            }

            /*Fixture.Freeze<Mock<IRequestService>>()
                .Setup(r => r.SendRequestAndThenAsync(It.IsAny<object>(), It.IsAny<Func<Task<ResponseString>>>(),
                    It.IsAny<Func<ResponseString, Task>>(), It.IsAny<Func<Task>>(), It.IsAny<Func<Task>>(),
                    It.IsAny<string>(), It.IsAny<string>())).Returns(SendRequestAndThenAsyncMock);*/
            
            var accountApiMock = Fixture.Freeze<Mock<IAccountApi>>();
            accountApiMock.Setup(a => a.V1AccountLoginPostAsync(It.IsAny<LoginDTO>()))
                .ReturnsUsingFixture(Fixture);
            var sut = Fixture.Create<LoginService>();
            var onSuccess = Fixture.Create<Func<Task>>();
            
            // Act
            await sut.LoginAndThenAsync(onSuccess, userType, username, password);

            // Assert
            accountApiMock.Verify(a => a.V1AccountLoginPostAsync(It.IsAny<LoginDTO>()));
        }

        [Fact]
        public async void LoginAndThenAsync_AccountApiThrowsError_SendsRequestFailedMessage()
        {
            // Arrange
            var accountApiMock = Fixture.Freeze<Mock<IAccountApi>>();
            accountApiMock.Setup(a => a.V1AccountLoginPostAsync(It.IsAny<LoginDTO>()))
                .Throws<ApiException>();
            var sut = Fixture.Create<LoginService>();

            var messageReceived = false;
            MessagingCenter.Subscribe<LoginService,string>(this, MessageKeys.RequestFailed,
                (sender, args) => { messageReceived = true;});

            // Act
            await sut.LoginAndThenAsync(Fixture.Create<Func<Task>>(), UserType.Guardian, "NotEmpty", "NotEmpty");
            
            // Assert
            Assert.True(messageReceived);
        }

        [Fact]
        public async void LoginAndThenAsync_UserTypeDepartmentAndSuccessResponse_SetsGuardianAuthToken()
        {
            // Arrange
            var settingsServiceMock = Fixture.Freeze<Mock<ISettingsService>>();
            
            var token = "GuardianAuthToken";
            var response = Fixture.Build<ResponseString>()
                .With(r => r.Success, true)
                .With(r => r.Data, token)
                .With(r => r.ErrorKey, ResponseString.ErrorKeyEnum.NoError)
                .Create();
            Fixture.Freeze<Mock<IAccountApi>>()
                .Setup(a => a.V1AccountLoginPostAsync(It.IsAny<LoginDTO>()))
                .ReturnsAsync(response);

            var sut = Fixture.Create<LoginService>();
            
            // Act
            await sut.LoginAndThenAsync(Fixture.Create<Func<Task>>(), UserType.Guardian, "NotEmpty", "NotEmpty");
            
            // Assert
            settingsServiceMock.VerifySet(s => s.GuardianAuthToken = token);
        }
        
        [Fact]
        public async void LoginAndThenAsync_UserTypeCitizenAndSuccessResponse_SetCitizenAuthToken()
        {
            // Arrange
            var settingsServiceMock = Fixture.Freeze<Mock<ISettingsService>>();
            
            var token = "CitizenAuthToken";
            var response = Fixture.Build<ResponseString>()
                .With(r => r.Success, true)
                .With(r => r.Data, token)
                .With(r => r.ErrorKey, ResponseString.ErrorKeyEnum.NoError)
                .Create();
            Fixture.Freeze<Mock<IAccountApi>>()
                .Setup(a => a.V1AccountLoginPostAsync(It.IsAny<LoginDTO>()))
                .ReturnsAsync(response);

            var sut = Fixture.Create<LoginService>();
            
            // Act
            await sut.LoginAndThenAsync(Fixture.Create<Func<Task>>(), UserType.Citizen, "NotEmpty", "NotEmpty");
            
            // Assert
            settingsServiceMock.VerifySet(s => s.CitizenAuthToken = token);
        }

        [Fact]
        public async void LoginAndThenAsync_SuccessfulReponse_InvokesUseTokenFor()
        {
            // Arrange
            var settingsServiceMock = Fixture.Freeze<Mock<ISettingsService>>();

            var userType = UserType.Citizen;
            var response = Fixture.Build<ResponseString>()
                .With(r => r.Success, true)
                .With(r => r.ErrorKey, ResponseString.ErrorKeyEnum.NoError)
                .Create();
            
            Fixture.Freeze<Mock<IAccountApi>>()
                .Setup(a => a.V1AccountLoginPostAsync(It.IsAny<LoginDTO>()))
                .ReturnsAsync(response);

            var sut = Fixture.Create<LoginService>();
            
            // Act
            await sut.LoginAndThenAsync(Fixture.Create<Func<Task>>(), userType, "NotEmpty", "NotEmpty");
            
            // Assert
            settingsServiceMock.Verify(s => s.UseTokenFor(userType));
        }

        [Fact]
        public async void LoginAndThenAsync_SuccessfulResponse_InvokesOnSucces()
        {
            // Arrange
            var response = Fixture.Build<ResponseString>()
                .With(r => r.Success, true)
                .With(r => r.ErrorKey, ResponseString.ErrorKeyEnum.NoError)
                .Create();

            var onSuccessInvoked = false;
            Func<Task> onSuccess = async () => { onSuccessInvoked = true; };
            
            Fixture.Freeze<Mock<IAccountApi>>()
                .Setup(a => a.V1AccountLoginPostAsync(It.IsAny<LoginDTO>()))
                .ReturnsAsync(response);

            var sut = Fixture.Create<LoginService>();
            
            // Act
            await sut.LoginAndThenAsync(onSuccess, UserType.Citizen, "NotEmpty", "NotEmpty");
            
            // Assert
            Assert.True(onSuccessInvoked);
        }

        [Fact]
        public async void LoginAndThenAsync_SuccessFalseInResponse_SendsLoginFailedMessage()
        {
            // Arrange
            var response = Fixture.Build<ResponseString>()
                .With(r => r.Success, false)
                .With(r => r.ErrorKey, ResponseString.ErrorKeyEnum.Error)
                .Create();
            var accountApiMock = Fixture.Freeze<Mock<IAccountApi>>();
            accountApiMock.Setup(a => a.V1AccountLoginPostAsync(It.IsAny<LoginDTO>()))
                .ReturnsAsync(response);
            var sut = Fixture.Create<LoginService>();

            var messageReceived = false;
            MessagingCenter.Subscribe<LoginService,string>(this, MessageKeys.LoginFailed,
                (sender, args) => { messageReceived = true;});

            // Act
            await sut.LoginAndThenAsync(Fixture.Create<Func<Task>>(), UserType.Guardian, "NotEmpty", "NotEmpty");
            
            // Assert
            Assert.True(messageReceived);
        }
        
    }
}