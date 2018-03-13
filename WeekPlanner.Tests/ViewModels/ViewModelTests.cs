using System.Threading.Tasks;
using AutoFixture;
using AutoFixture.AutoMoq;
using IO.Swagger.Client;
using IO.Swagger.Model;
using Moq;
using WeekPlanner.Services.Networking;
using WeekPlanner.ViewModels;
using Xamarin.Forms;
using Xunit;

namespace WeekPlanner.Tests.ViewModels
{
    public class ViewModelTests
    {
        private readonly IFixture _fixture;

        public ViewModelTests()
        {
            _fixture = new Fixture().Customize(new AutoMoqCustomization());
        }

        // Use the naming convention MethodName_StateUnderTest_ExpectedBehavior

        [Fact]
        public void LoginCommand_Condition_Success()
        {
            // Arrange
            bool messageReceived = false;

            // Fails due to circular dependency in ReponseGirafUserDTO
            var networkServiceMock = _fixture.Freeze<Mock<INetworkingService>>();
            networkServiceMock.Setup(n => n.SendLoginRequest(It.IsAny<string>(), It.IsAny<string>()))
                              .ReturnsAsync(_fixture.Create<ResponseGirafUserDTO>());

            var loginViewModel = _fixture.Build<LoginViewModel>()
                                         .With(l => l.Username, "Graatand")
                                         .With(l => l.Password, "password")
                                         .Create();

            MessagingCenter.Subscribe<LoginViewModel>(this, "LoginSuccess", _ =>
            {
                messageReceived = true;
            });

            // Act
            loginViewModel.LoginCommand.Execute(null);

            // Assert
            Assert.True(messageReceived);
        }

        [Fact]
        public async void LoginCommand_ServerDown_SendsLoginFailMsg()
        {
            // Arrange
            bool messageReceived = false;

            // Freeze makes it so AutoFixture uses this particular object if it is needed
            var networkServiceMock = _fixture.Freeze<Mock<INetworkingService>>();
            networkServiceMock.Setup(n => n.SendLoginRequest(It.IsAny<string>(), It.IsAny<string>()))
                              .Throws<ApiException>();

            var loginViewModel = _fixture.Build<LoginViewModel>()
                                         .With(l => l.Username, "Graatand")
                                         .With(l => l.Password, "password")
                                         .Create();

            MessagingCenter.Subscribe<LoginViewModel, string>(this, "LoginFailed", (sender, args) =>
            {
                messageReceived = true;
            });

            // Act
            await Task.Run(() => loginViewModel.LoginCommand.Execute(null));

            // Assert
            Assert.True(messageReceived);
        }
    }
}
