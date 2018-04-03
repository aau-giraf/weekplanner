using System.Threading.Tasks;
using AutoFixture;
using IO.Swagger.Api;
using IO.Swagger.Client;
using IO.Swagger.Model;
using Moq;
using WeekPlanner.Validations;
using WeekPlanner.ViewModels;
using WeekPlanner.ViewModels.Base;
using Xamarin.Forms;
using Xunit;

namespace WeekPlanner.Tests.UnitTests.ViewModels
{
    /*public class ViewModelTestses : TestsBase
    {
        // Use the naming convention MethodName_StateUnderTest_ExpectedBehavior

        [Fact]
        public async void LoginCommand_ApiReturnsSuccess_Success()
        {
            // Arrange
            bool messageReceived = false;

            var response = Fixture.Build<ResponseGirafUserDTO>().With(r => r.Success, true).Create();
            var accountApiMock = Fixture.Freeze<Mock<IAccountApi>>();
            accountApiMock.Setup(n => n.V1AccountLoginPostAsync(It.IsAny<LoginDTO>()))
                              .ReturnsAsync(response);

            var loginViewModel = Fixture.Create<LoginViewModel>();

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
            var accountApiMock = Fixture.Freeze<Mock<IAccountApi>>();
            accountApiMock.Setup(n => n.V1AccountLoginPostAsync(It.IsAny<LoginDTO>()))
                              .Throws<ApiException>();

            var username = Fixture.Build<ValidatableObject<string>>()
                .With(v => v.Value, "Graatand").Create();
            var password = Fixture.Build<ValidatableObject<string>>()
                .With(v => v.Value, "password").Create();
            
            var loginViewModel = Fixture.Build<LoginViewModel>()
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
    }*/
}
