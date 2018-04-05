using System;
using System.Collections.Generic;
using System.Text;
using WeekPlanner.ViewModels;
using AutoFixture;
using Xunit;
using WeekPlanner.Services.Navigation;
using Moq;
using WeekPlanner.Tests.UnitTests.Base;

namespace WeekPlanner.Tests.UnitTests.ViewModels
{
    public class UserModeSwitchViewModelTests : TestsBase
    {
        [Fact]
        public void UserModeProperty_OnChange_RaisePropertyChanged()
        {
            //Arrange
            var sut = Fixture.Create<UserModeSwitchViewModel>();

            bool invoked = false;
            sut.PropertyChanged += (sender, e) =>
            {
                if (e.PropertyName.Equals(nameof(sut.Mode)))
                    invoked = true;
            };

            //Act
            sut.SwitchUserModeCommand.Execute(true);

            //Assert
            Assert.True(invoked);
        }

        [Fact]
        public void ChooseCitizenCommand_Executed_InvokesNavigateToWeekPlanner()
        {
            // Arrange
            var navServiceMock = Fixture.Freeze<Mock<INavigationService>>();
            var sut = Fixture.Create<UserModeSwitchViewModel>();

            // Act
            sut.SwitchUserModeCommand.Execute(true);
            sut.SwitchUserModeCommand.Execute(true);

            // Assert
            navServiceMock.Verify(n => n.NavigateToAsync<LoginViewModel>(It.IsAny<UserModeSwitchViewModel>()));
        }
    }
}
