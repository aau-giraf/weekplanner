using System;
using IO.Swagger.Model;
using WeekPlanner.ViewModels;
using Xamarin.Forms;
using Xunit;

namespace WeekPlanner.Tests
{
    public class ViewModelTests
    {
        [Fact]
        public void Login_Success()
        {
            // Arrange
            bool messageReceived = false;
            var loginViewModel = new LoginViewModel
            {
                Username = "Graatand",
                Password = "password",
            };

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
            var loginViewModel = new LoginViewModel
            {
                Username = "Graatand",
                Password = "password",
            };

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
