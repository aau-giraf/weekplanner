using System;
using System.Collections.ObjectModel;
using AutoFixture;
using AutoFixture.Xunit2;
using IO.Swagger.Model;
using Moq;
using WeekPlanner.Services.Navigation;
using WeekPlanner.ViewModels;
using Xunit;

namespace WeekPlanner.Tests.UnitTests.ViewModels
{
    public class ChooseCitizenViewModelTests : ViewModelTestsBase
    {
        [Fact]
        public async void CitizensProperty_AfterInitializationWithValidArguments_IsNotNull()
        {
            // Arrange
            var dtos = Fixture.CreateMany<GirafUserDTO>();
            var sut = Fixture.Build<ChooseCitizenViewModel>()
                .OmitAutoProperties().Create();

            // Act
            await sut.InitializeAsync(dtos);
            
            // Assert
            Assert.NotNull(sut.Citizens);
        }

        [Theory, AutoData]
        public async void InitializeAsync_InvalidArguments_ThrowsArgumentException(object arg)
        {
            // Arrange
            var sut = Fixture.Create<ChooseCitizenViewModel>();

            // Assert                                                       Act
            await Assert.ThrowsAsync<ArgumentException>(async () => await sut.InitializeAsync(arg));
        }
        
        [Fact]
        public async void InitializeAsync_NullArgument_ThrowsArgumentException()
        {
            // Arrange
            var sut = Fixture.Create<ChooseCitizenViewModel>();

            // Assert                                                       Act
            await Assert.ThrowsAsync<ArgumentException>(async () => await sut.InitializeAsync(null));
        }
        
        [Fact]
        public void CitizensProperty_OnSet_RaisePropertyChanged()
        {
            // Arrange
            var sut = Fixture.Create<ChooseCitizenViewModel>();
            
            bool invoked = false;
            sut.PropertyChanged += (sender, e) =>
            {
                if (e.PropertyName.Equals(nameof(sut.Citizens)))
                    invoked = true;
            };
            // Act
            sut.Citizens = new ObservableCollection<GirafUserDTO>();
            
            // Assert
            Assert.True(invoked);
        }

        [Fact]
        public void ChooseCitizenCommand_IsNotNull()
        {
            // Arrange
            var sut = Fixture.Build<ChooseCitizenViewModel>()
                .OmitAutoProperties()
                .Create();
            
            // Assert
            Assert.NotNull(sut.ChooseCitizenCommand);
        }

        [Fact]
        public void ChooseCitizenCommand_Executed_InvokesNavigateToWeekPlanner()
        {
            // Arrange
            var arg = Fixture.Create<GirafUserDTO>();
            var navServiceMock = Fixture.Freeze<Mock<INavigationService>>();
            var sut = Fixture.Create<ChooseCitizenViewModel>();
            
            // Act
            sut.ChooseCitizenCommand.Execute(arg);
            
            // Assert
            navServiceMock.Verify(n => n.NavigateToAsync<WeekPlannerViewModel>(It.IsAny<GirafUserDTO>()));
        }
    }
}