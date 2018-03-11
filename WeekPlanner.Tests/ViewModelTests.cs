using System;
using IO.Swagger.Model;
using WeekPlanner.ViewModels;
using Xamarin.Forms;
using Xunit;
using AutoFixture;
using AutoFixture.AutoMoq;

namespace WeekPlanner.Tests
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
        public void Login_Success()
        {
            // Arrange
            bool messageReceived = false;

            var loginViewModel = _fixture.Build<LoginViewModel>()
                                         .With(l => l.Username, "Graatand")
                                         .With(l => l.Password, "password")
                                         .Create();

            MessagingCenter.Subscribe<LoginViewModel>(this, "LoginSuccess", (sender) =>
            {
                messageReceived = true;
            });

            // Act
            loginViewModel.LoginCommand.Execute(null);

            // Assert
            Assert.True(messageReceived);
        }

        [Fact]
        public void Login_Fail()
        {
            // Arrange
            bool messageReceived = false;

            var loginViewModel = _fixture.Build<LoginViewModel>()
                                         .With(l => l.Username, "Graatand")
                                         .With(l => l.Password, "password")
                                         .Create();

            MessagingCenter.Subscribe<LoginViewModel>(this, "LoginFail", (sender) =>
            {
                messageReceived = true;
            });

            // Act
            loginViewModel.LoginCommand.Execute(null);

            // Assert
            Assert.True(messageReceived);
        }
    }
}
