using System.Collections.Generic;
using System.Collections.ObjectModel;
using AutoFixture;
using IO.Swagger.Api;
using IO.Swagger.Client;
using IO.Swagger.Model;
using Moq;
using WeekPlanner.Services.Navigation;
using WeekPlanner.Services.Settings;
using WeekPlanner.Tests.UnitTests.Base;
using WeekPlanner.ViewModels;
using WeekPlanner.ViewModels.Base;
using Xamarin.Forms;
using Xunit;

namespace WeekPlanner.Tests.UnitTests.ViewModels
{
    public class ChooseCitizenTests : TestsBase
    {
        [Fact]
        public void CitizenNamesProperty_OnSet_RaisesPropertyChanged()
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
        public async void CitizenNamesProperty_AfterInitializationWithValidArguments_IsNotNull()
        {
            // Arrange
            var response = Fixture.Build<ResponseListUserNameDTO>()
                .With(r => r.Data, Fixture.Create<List<UserNameDTO>>())
                .With(r => r.Success, true)
                .With(r => r.ErrorKey, ResponseListUserNameDTO.ErrorKeyEnum.NoError)
                .Create();
            
            var departmentApiMock = Fixture.Freeze<Mock<IDepartmentApi>>();
            departmentApiMock.Setup(d => d.V1DepartmentByIdCitizensGetAsync(It.IsAny<long?>()))
                .ReturnsAsync(response);

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
            
            // Necessary because AutoFixture can't automatically setup the mock method calls
            var response = Fixture.Create<ResponseListUserNameDTO>();
            var departmentApiMock = Fixture.Freeze<Mock<IDepartmentApi>>();
            departmentApiMock.Setup(d => d.V1DepartmentByIdCitizensGetAsync(It.IsAny<long?>()))
                .ReturnsAsync(response);
            
            var sut = Fixture.Create<ChooseCitizenViewModel>();
            
            // Act
            await sut.InitializeAsync(null);
            
            // Assert
            settingsServiceMock.Verify(s => s.UseTokenFor(UserType.Department));
        }
        
        [Fact]
        public async void InitializeAsync_ResultIsFalse_SendsMessage()
        {
            // Arrange
            bool messageReceived = false;
            MessagingCenter.Subscribe<ChooseCitizenViewModel, string>(this, MessageKeys.CitizenListRetrievalFailed, (sender, args) =>
            {   
                messageReceived = true;
            });
            
            var response = Fixture.Build<ResponseListUserNameDTO>()
                .With(r => r.Success, false)
                .Create();
            
            Fixture.Freeze<Mock<IDepartmentApi>>()
                .Setup(d => d.V1DepartmentByIdCitizensGetAsync(It.IsAny<long?>()))
                .ThrowsAsync(Fixture.Create<ApiException>());
            
            var sut = Fixture.Create<ChooseCitizenViewModel>();
            
            // Act
            await sut.InitializeAsync(null);
            
            // Assert
            Assert.True(messageReceived);
        }
        
        [Fact]
        public async void InitializeAsync_ApiExceptionThrown_SendsMessage()
        {
            // Arrange
            bool messageReceived = false;
            MessagingCenter.Subscribe<ChooseCitizenViewModel, string>(this, MessageKeys.CitizenListRetrievalFailed, (sender, args) =>
            {
                messageReceived = true;
            });
            
            Fixture.Freeze<Mock<IDepartmentApi>>()
                .Setup(d => d.V1DepartmentByIdCitizensGetAsync(It.IsAny<long?>()))
                .ThrowsAsync(Fixture.Create<ApiException>());
            
            var sut = Fixture.Create<ChooseCitizenViewModel>();
            
            // Act
            await sut.InitializeAsync(null);
            
            // Assert
            Assert.True(messageReceived);
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