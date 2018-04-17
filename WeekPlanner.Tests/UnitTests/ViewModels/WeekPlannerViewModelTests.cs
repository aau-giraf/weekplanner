using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using AutoFixture;
using IO.Swagger.Api;
using IO.Swagger.Model;
using Moq;
using WeekPlanner.Services.Navigation;
using WeekPlanner.Services.Login;
using WeekPlanner.Services.Settings;
using WeekPlanner.ViewModels;
using Xamarin.Forms;
using Xunit;

namespace WeekPlanner.Tests.UnitTests.ViewModels
{
    public class WeekPlannerViewModelTests : Base.TestsBase
    {
        [Theory]
        [InlineData("MondayPictos")]
        [InlineData("TuesdayPictos")]
        [InlineData("WednesdayPictos")]
        [InlineData("ThursdayPictos")]
        [InlineData("FridayPictos")]
        [InlineData("SaturdayPictos")]
        [InlineData("SundayPictos")]
        [InlineData("SundayPictos")]
        [InlineData("CountOfMaxHeightWeekday")]
        public void WeekdayPictos_OnSet_RaisesPropertiesChanged(string property)
        {
            //Arrange
            var sut = Fixture.Create<WeekPlannerViewModel>();
            bool invoked = false;
            sut.PropertyChanged += (sender, e) =>
            {
                if (e.PropertyName.Equals(property))
                    invoked = true;
            };

            //Act
            sut.WeekdayPictos = new Dictionary<WeekdayDTO.DayEnum, ObservableCollection<String>>();

            //Assert
            Assert.True(invoked);
        }

        [Fact]
        public async Task MondayPictosProperty_AfterInitAsync_ReturnsCorrectPictos()
        {
            //Arrange
            var mockUsernameDTO = Fixture.Create<UserNameDTO>();
            Func<Func<Task>, UserType, string, string, Task> loginAndThenMock =
                async (onSuccess, userType, username, password) => await onSuccess.Invoke();

            var mockLogin = Fixture.Freeze<Mock<ILoginService>>().Setup(l =>
                    l.LoginAndThenAsync(It.IsAny<Func<Task>>(), UserType.Citizen, mockUsernameDTO.UserName, ""))
                .Returns(loginAndThenMock);

            var response = Fixture.Build<ResponseWeekDTO>()
                .With(r => r.Data, Fixture.Create<WeekDTO>())
                .With(r => r.Success, true)
                .With(r => r.ErrorKey, ResponseWeekDTO.ErrorKeyEnum.NoError)
                .Create();
            var mockWeek = Fixture.Freeze<Mock<IWeekApi>>()
                .Setup(w => w.V1WeekByIdGetAsync(It.IsAny<long?>()))
                .ReturnsAsync(response);

            var sut = Fixture.Build<WeekPlannerViewModel>().OmitAutoProperties().Create();
            //Act
            await sut.InitializeAsync(mockUsernameDTO);

            var mondayIds =
                sut.MondayPictos.Select(p =>
                        Convert.ToInt64(Regex.Match(p.ToString(), "pictogram/(.*)/image").Groups[1].Value))
                    .ToList();

            var mondayIdsFromWeek = response.Data.Days[0].ElementIDs.Select(i => i.Value).ToList();
            //Assert
            Assert.Equal(mondayIdsFromWeek, mondayIds);
        }

        [Fact]
        public async void CountOfMaxHeightWeekday_AfterInitAsync_returnsCorrectCount()
        {
            //Arrange
            var mockUsernameDTO = Fixture.Create<UserNameDTO>();

            async Task LoginAndThenMock(Func<Task> onSuccess, UserType userType, string username, string password) =>
                await onSuccess.Invoke();

            var mockLogin = Fixture.Freeze<Mock<ILoginService>>().Setup(l =>
                    l.LoginAndThenAsync(It.IsAny<Func<Task>>(), UserType.Citizen, mockUsernameDTO.UserName, ""))
                .Returns((Func<Func<Task>, UserType, string, string, Task>) LoginAndThenMock);

            var weekResponse = Fixture.Build<ResponseWeekDTO>()
                .With(r => r.Success, true)
                .With(r => r.ErrorKey, ResponseWeekDTO.ErrorKeyEnum.NoError)
                .With(r => r.Data, Fixture.Create<WeekDTO>()).Create();

            var mockWeek = Fixture.Freeze<Mock<IWeekApi>>()
                .Setup(w => w.V1WeekByIdGetAsync(It.IsAny<long?>()))
                .ReturnsAsync(weekResponse);
            var sut = Fixture.Build<WeekPlannerViewModel>().OmitAutoProperties().Create();
            //Act 
            await sut.InitializeAsync(mockUsernameDTO);
            //Assert
            Assert.Equal(weekResponse.Data.Days.Max(d => d.ElementIDs.Count), sut.CountOfMaxHeightWeekday);
        }

        [Fact]
        public void WeekdayPictos_AfterInitAsync_IsNotNull()
        {
            //Arrange
            var weekResponse = Fixture.Build<ResponseWeekDTO>()
                .With(r => r.Success, true)
                .With(r => r.ErrorKey, ResponseWeekDTO.ErrorKeyEnum.NoError)
                .With(r => r.Data, Fixture.Create<WeekDTO>()).Create();

            var mockWeek = Fixture.Freeze<Mock<IWeekApi>>()
                .Setup(w => w.V1WeekByIdGetAsync(It.IsAny<long?>()))
                .ReturnsAsync(weekResponse);

            var pictoResponse = Fixture.Build<ResponsePictogramDTO>()
                .With(r => r.Success, true)
                .With(r => r.ErrorKey, ResponsePictogramDTO.ErrorKeyEnum.NoError)
                .With(r => r.Data, Fixture.Create<PictogramDTO>()).Create();


            var sut = Fixture.Build<WeekPlannerViewModel>().OmitAutoProperties().Create();
            //Act
            sut.InitializeAsync(null);
            //Assert
            Assert.NotNull(sut.WeekdayPictos);
        }

        [Fact]
        public void EditModeProperty_OnChange_RaisePropertyChanged()
        {
            //Arrange
            var sut = Fixture.Create<WeekPlannerViewModel>();

            bool invoked = false;
            sut.PropertyChanged += (sender, e) =>
            {
                if (e.PropertyName.Equals(nameof(sut.EditModeEnabled)))
                    invoked = true;
            };

            //Act
            sut.ToggleEditModeCommand.Execute(true);

            //Assert
            Assert.True(invoked);
        }

        [Fact]
        public void ModeImageProperty_OnChange_RaisePropertyChanged()
        {
            //Arrange
            var sut = Fixture.Create<WeekPlannerViewModel>();

            bool invoked = false;
            sut.PropertyChanged += (sender, e) =>
            {
                if (e.PropertyName.Equals(nameof(sut.UserModeImage)))
                    invoked = true;
            };

            //Act
            sut.ToggleEditModeCommand.Execute(true);

            //Assert
            Assert.True(invoked);
        }

        [Fact]
        public void ToogleEditModeCommand_Executed_InvokesNavigateToLoginPage()
        {
            // Arrange
            var navServiceMock = Fixture.Freeze<Mock<INavigationService>>();
            var sut = Fixture.Create<WeekPlannerViewModel>();

            // Act
            sut.ToggleEditModeCommand.Execute(true);
            sut.ToggleEditModeCommand.Execute(true);

            // Assert
            navServiceMock.Verify(n => n.NavigateToAsync<LoginViewModel>(It.IsAny<WeekPlannerViewModel>()));
        }
    }
}