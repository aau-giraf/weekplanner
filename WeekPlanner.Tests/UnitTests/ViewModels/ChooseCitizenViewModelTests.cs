using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using AutoFixture;
using IO.Swagger.Api;
using IO.Swagger.Model;
using Moq;
using WeekPlanner.Services.Navigation;
using WeekPlanner.Services.Settings;
using WeekPlanner.ViewModels;
using Xunit;

namespace WeekPlanner.Tests.UnitTests.ViewModels
{
    public class ChooseCitizenViewModelTests : ViewModelTestsBase
    {
        [Fact]
        public async void CitizenNamesProperty_AfterInitializationWithValidArguments_IsNotNull()
        {
            // Arrange
            var dto = Fixture.Build<ResponseListUserNameDTO>()
                .With(r => r.Data, Fixture.Create<List<UserNameDTO>>())
                .With(r => r.Success, true)
                .With(r => r.ErrorKey, ResponseListUserNameDTO.ErrorKeyEnum.NoError)
                .Create();
            
            var departmentApiMock = Fixture.Freeze<Mock<IDepartmentApi>>();
            departmentApiMock.Setup(d => d.V1DepartmentByIdCitizensGetAsync(It.IsAny<long?>()))
                .ReturnsAsync(dto);

            var sut = Fixture.Build<ChooseCitizenViewModel>()
                .OmitAutoProperties().Create();

            // Act
            await sut.InitializeAsync(null);
            
            // Assert
            Assert.NotNull(sut.CitizenNames);
        }

        [Fact]
        public async void InitializeAsync_Executed_InvokesUseTokenForDepartment()
        {
            // Arrange
            var settingsServiceMock = Fixture.Freeze<Mock<ISettingsService>>();
            
            // 
            var dto = Fixture.Create<ResponseListUserNameDTO>();
                /*.With(r => r.Data, Fixture.Create<List<UserNameDTO>>())
                .With(r => r.Success, true)
                .With(r => r.ErrorKey, ResponseListUserNameDTO.ErrorKeyEnum.NoError)
                .Create();*/
            var departmentApiMock = Fixture.Freeze<Mock<IDepartmentApi>>();
            departmentApiMock.Setup(d => d.V1DepartmentByIdCitizensGetAsync(It.IsAny<long?>()))
                .ReturnsAsync(dto);
            
            var sut = Fixture.Create<ChooseCitizenViewModel>();
            
            // Act
            await sut.InitializeAsync(null);
            
            // Assert
            settingsServiceMock.Verify(s => s.UseTokenFor(UserType.Department));
        }
        
        [Fact]
        public void CitizenNamesProperty_OnSet_RaisePropertyChanged()
        {
            // Arrange
            var sut = Fixture.Create<ChooseCitizenViewModel>();
            
            bool invoked = false;
            sut.PropertyChanged += (sender, e) =>
            {
                if (e.PropertyName.Equals(nameof(sut.CitizenNames)))
                    invoked = true;
            };
            // Act
            sut.CitizenNames = new ObservableCollection<UserNameDTO>();
            
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
            var usernameDTO = Fixture.Create<UserNameDTO>();
            var navServiceMock = Fixture.Freeze<Mock<INavigationService>>();
            var sut = Fixture.Create<ChooseCitizenViewModel>();
            
            // Act
            sut.ChooseCitizenCommand.Execute(usernameDTO);
            
            // Assert
            navServiceMock.Verify(n => n.NavigateToAsync<WeekPlannerViewModel>(It.IsAny<UserNameDTO>()));
        }

        [Fact]
        public void ChooseCitizenCommand_Executed_InvokesUseTokenForDepartment()
        {
            // Arrange
            var usernameDTO = Fixture.Create<UserNameDTO>();
            var settingsServiceMock = Fixture.Freeze<Mock<ISettingsService>>();
            var sut = Fixture.Create<ChooseCitizenViewModel>();
            
            // Act
            sut.ChooseCitizenCommand.Execute(usernameDTO);
            
            // Assert
            settingsServiceMock.Verify(s => s.UseTokenFor(UserType.Department));
        }
    }
}