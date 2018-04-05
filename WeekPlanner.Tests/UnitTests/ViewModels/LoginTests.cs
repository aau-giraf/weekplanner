using System;
using System.Threading.Tasks;
using AutoFixture;
using Moq;
using WeekPlanner.Services.Login;
using WeekPlanner.Services.Navigation;
using WeekPlanner.Services.Settings;
using WeekPlanner.Tests.UnitTests.Base;
using WeekPlanner.Validations;
using WeekPlanner.ViewModels;
using Xunit;

namespace WeekPlanner.Tests.UnitTests.ViewModels
{
    public class LoginTests : TestsBase
    {
        [Fact]
        public void PasswordProperty_AfterCreation_IsNotNull()
        {
            // Arrange
            var sut = Fixture.Build<LoginViewModel>()
                .OmitAutoProperties()
                .Create();
            
            // Assert
            Assert.NotNull(sut.Password);
        }
        
        [Fact]
        public void PasswordProperty_OnSet_RaisesPropertyChanged()
        {
            // Arrange
            var sut = Fixture.Create<LoginViewModel>();
            
            bool invoked = false;
            sut.PropertyChanged += (sender, e) =>
            {
                if (e.PropertyName.Equals(nameof(sut.Password)))
                    invoked = true;
            };
            
            // Act
            sut.Password = Fixture.Create<ValidatableObject<string>>();
            
            // Assert
            Assert.True(invoked);
        }
        
        [Fact]
        public void ValidatePasswordCommand_IsNotNull()
        {
            // Arrange
            var sut = Fixture.Build<LoginViewModel>()
                .OmitAutoProperties()
                .Create();
            
            // Assert
            Assert.NotNull(sut.ValidatePasswordCommand);
        }
        
        [Theory]
        [InlineData("NotEmpty", "Also Not Empty")]
        [InlineData("   .", "Not empty")]
        [InlineData("#€%€&%/%&", "#€%=/()&(&/(  34345")]
        public void UserNameAndPasswordIsValid_UserNameAndPasswordNotNullOrEmpty_True(string username, 
            string password)
        {
            // Arrange
            var sut = Fixture.Build<LoginViewModel>()
                .OmitAutoProperties()
                .Create();
            
            // Act
            sut.Password.Value = password;
            
            // Assert
            Assert.True(sut.UserNameAndPasswordIsValid());
        }

        [Theory]
        [InlineData("NotEmpty", "")]
        [InlineData("NotEmpty", null)]
        [InlineData("", "NotEmpty")]
        [InlineData("", "")]
        [InlineData("", null)]
        [InlineData(null, "NotEmpty")]
        [InlineData(null, "")]
        [InlineData(null, null)]
        public void UserNameAndPasswordIsValid_UserNameOrPasswordIsNullOrEmpty_IsFalse(string username, string password)
        {
            // Arrange
            var sut = Fixture.Build<LoginViewModel>()
                .OmitAutoProperties()
                .Create();
            
            // Act
            sut.Password.Value = password;
            
            // Assert
            Assert.False(sut.UserNameAndPasswordIsValid());
        }

        [Fact]
        public async void LoginCommand_ExecutedWithValidCredentials_InvokesLoginAndThen()
        {
            // Arrange 
            var loginServiceMock = Fixture.Freeze<Mock<ILoginService>>();
            var sut = Fixture.Build<LoginViewModel>()
                .OmitAutoProperties()
                .Create();
            sut.Password.Value = "ValidPassword";

            // Act
            await Task.Run(() => sut.LoginCommand.Execute(null));

            // Assert
            loginServiceMock.Verify(ls => ls.LoginAndThenAsync(It.IsAny<Func<Task>>(), UserType.Department, 
                It.IsAny<string>(), It.IsAny<string>()));
        }

        [Fact]
        public async void LoginCommand_ExecutedWithInvalidCredentials_DoesNothing()
        {
            // Arrange 
            var loginServiceMock = Fixture.Freeze<Mock<ILoginService>>();
            var sut = Fixture.Build<LoginViewModel>()
                .OmitAutoProperties()
                .Create();
            sut.Password.Value = "";

            // Act
            await Task.Run(() => sut.LoginCommand.Execute(null));

            // Assert
            loginServiceMock.Verify(ls => ls.LoginAndThenAsync(It.IsAny<Func<Task>>(), UserType.Department, 
                It.IsAny<string>(), It.IsAny<string>()), Times.Never);
        }

        [Fact]
        public async void LoginCommand_ExecutedWithValidCredentials_EventuallyNavigatesToChooseCitizenViewModel()
        {
            // Arrange
            Func<Func<Task>, UserType, string, string, Task> loginAndThenMock =
                async (onSuccess, userType, username, password) => await onSuccess.Invoke();
            
            var navigationServiceMock = Fixture.Freeze<Mock<INavigationService>>();
            
            var loginServiceMock = Fixture.Freeze<Mock<ILoginService>>()
                .Setup(l => l.LoginAndThenAsync(It.IsAny<Func<Task>>(), UserType.Department, It.IsAny<string>(),
                    It.IsAny<string>()))
                .Returns(loginAndThenMock);
            
            var sut = Fixture.Build<LoginViewModel>()
                .OmitAutoProperties()
                .Create();

            sut.Password.Value = "ValidPassword";
            
            // Act
            await Task.Run(() => sut.LoginCommand.Execute(null));
            
            // Assert
            navigationServiceMock.Verify(n => n.NavigateToAsync<ChooseCitizenViewModel>(null));
        }
    }
}