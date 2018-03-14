using System.Threading.Tasks;
using AutoFixture;
using AutoFixture.AutoMoq;
using IO.Swagger.Api;
using IO.Swagger.Client;
using IO.Swagger.Model;
using Moq;
using WeekPlanner.Validations;
using WeekPlanner.ViewModels;
using WeekPlanner.ViewModels.Base;
using Xamarin.Forms;
using Xunit;
using WeekPlanner.ApplicationObjects;
using WeekPlanner.Services.Navigation;
using Autofac;
using System.Linq;

namespace WeekPlanner.Tests.ViewModels
{
    public class ViewModelTests
    {
        private readonly IFixture _fixture;

        public ViewModelTests()
        {
            _fixture = new Fixture().Customize(new AutoMoqCustomization());
            _fixture.Behaviors.OfType<ThrowingRecursionBehavior>().ToList()
                     .ForEach(b => _fixture.Behaviors.Remove(b));
            _fixture.Behaviors.Add(new OmitOnRecursionBehavior());//recursionDepth

        }

        // Use the naming convention MethodName_StateUnderTest_ExpectedBehavior

        [Fact]
        public async void LoginCommand_ApiReturnsSuccess_Success()
        {
            // Arrange
            bool messageReceived = false;

            var response = _fixture.Build<ResponseGirafUserDTO>().With(r => r.Success, true).Create();
            var accountApiMock = _fixture.Freeze<Mock<IAccountApi>>();
            accountApiMock.Setup(n => n.V1AccountLoginPostAsync(It.IsAny<LoginDTO>()))
                              .ReturnsAsync(response);

            var loginViewModel = _fixture.Create<LoginViewModel>();

            MessagingCenter.Subscribe<LoginViewModel, GirafUserDTO>(this, MessageKeys.LoginSucceeded, (sender, args) =>
            {
                messageReceived = true;
               });

            // Act
            await Task.Run(() => loginViewModel.LoginCommand.Execute(null));

            // Assert
            Assert.True(messageReceived);
        }


        [Fact]
        public async void LoginCommand_ApiThrowsError_SendsLoginFailMsg()
        {
            // Arrange
            bool messageReceived = false;

            // Freeze makes it so AutoFixture uses this particular object if it is needed
            var accountApiMock = _fixture.Freeze<Mock<IAccountApi>>();
            accountApiMock.Setup(n => n.V1AccountLoginPostAsync(It.IsAny<LoginDTO>()))
                              .Throws<ApiException>();

            var username = _fixture.Build<ValidatableObject<string>>()
                .With(v => v.Value, "Graatand").Create();
            var password = _fixture.Build<ValidatableObject<string>>()
                .With(v => v.Value, "password").Create();
            
            var loginViewModel = _fixture.Build<LoginViewModel>()
                .With(l => l.UserName, username)
                .With(l => l.Password, password)
                .Create();

            MessagingCenter.Subscribe<LoginViewModel, string>(this, MessageKeys.LoginFailed, (sender, args) =>
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
