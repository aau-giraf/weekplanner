using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Linq;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using AutoFixture;
using AutoFixture.AutoMoq;
using IO.Swagger.Api;
using IO.Swagger.Model;
using Microsoft.VisualStudio.TestPlatform.CommunicationUtilities.DataCollection;
using Moq;
using WeekPlanner.Services.Navigation;
using WeekPlanner.Services.Login;
using WeekPlanner.Services.Request;
using WeekPlanner.Services.Settings;
using WeekPlanner.Services;
using WeekPlanner.ViewModels;
using Xunit;
using Assert = Xunit.Assert;
using Xamarin.Forms;
using WeekPlanner.Views;
using WeekPlanner.ViewModels.Base;

namespace WeekPlanner.Tests.UnitTests.ViewModels
{
    public class WeekPlannerViewModelTests : Base.TestsBase
    {
        [Xunit.Theory]
        [InlineData("MondayPictos")]
        [InlineData("TuesdayPictos")]
        [InlineData("WednesdayPictos")]
        [InlineData("ThursdayPictos")]
        [InlineData("FridayPictos")]
        [InlineData("SaturdayPictos")]
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
            sut.WeekdayPictos = new Dictionary<WeekdayDTO.DayEnum, ObservableCollection<string>>();

            //Assert
            Assert.True(invoked);
        }

        [Xunit.Theory]
        [InlineData(WeekdayDTO.DayEnum.Monday)]
        [InlineData(WeekdayDTO.DayEnum.Tuesday)]
        [InlineData(WeekdayDTO.DayEnum.Wednesday)]
        [InlineData(WeekdayDTO.DayEnum.Thursday)]
        [InlineData(WeekdayDTO.DayEnum.Friday)]
        [InlineData(WeekdayDTO.DayEnum.Saturday)]
        [InlineData(WeekdayDTO.DayEnum.Sunday)]
        public async Task DayPictosProperty_AfterInitAsync_ReturnsCorrectPictos(WeekdayDTO.DayEnum day)
        {
            //Arrange
            var usernameDTO = Fixture.Create<UserNameDTO>();
            Func<Func<Task>, UserType, string, string, Task> loginAndThenMock =
                async (onSuccess, userType, username, password) => await onSuccess.Invoke();

            FreezeMockOfIRequestService<WeekPlannerViewModel, ResponseWeekDTO>();
            
            var mockLogin = Fixture.Freeze<Mock<ILoginService>>().Setup(l =>
                    l.LoginAndThenAsync(It.IsAny<Func<Task>>(), UserType.Citizen, usernameDTO.UserName, ""))
                .Returns(loginAndThenMock);

            var weekdays = new List<WeekdayDTO>();
            foreach (WeekdayDTO.DayEnum d in Enum.GetValues(typeof(WeekdayDTO.DayEnum)))
            {
                var weekdayDTO = Fixture.Build<WeekdayDTO>()
                    .With(w => w.Day, d)
                    .Create();
                weekdays.Add(weekdayDTO);
            }

            var weekDTO = Fixture.Build<WeekDTO>()
                .With(w => w.Days, weekdays).Create();

            var response = Fixture.Build<ResponseWeekDTO>()
                .With(r => r.Data, weekDTO)
                .With(r => r.Success, true)
                .With(r => r.ErrorKey, ResponseWeekDTO.ErrorKeyEnum.NoError)
                .Create();
            var mockWeek = Fixture.Freeze<Mock<IWeekApi>>()
                .Setup(w => w.V1WeekByIdGetAsync(It.IsAny<long?>()))
                .ReturnsAsync(response);

            var sut = Fixture.Build<WeekPlannerViewModel>().OmitAutoProperties().Create();

            //Act
            await sut.InitializeAsync(usernameDTO);

            var dayIds = sut.WeekdayPictos[day].Select(p => p).Select(p => 
                    Convert.ToInt64(Regex.Match(p.ToString(), "pictogram/(.*)/image").Groups[1].Value))
                .ToList();

            var dayIdsFromWeek =

                response.Data.Days.FirstOrDefault(d => d.Day == day)?.Activities.Select(e => e.Pictogram.Id).Select(i => i.Value)
                    .ToList();

            //Assert
            Assert.Equal(dayIdsFromWeek, dayIds);
        }

        public async Task WeekdayPictos_AfterInitAsync_IsNotNullAsync()
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
            await sut.InitializeAsync(null);
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
            sut.ToolbarButtonCommand.Execute(true);

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
                if (e.PropertyName.Equals(nameof(sut.ToolbarButtonIcon)))
                    invoked = true;
            };

            //Act
            sut.ToolbarButtonCommand.Execute(true);

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
            sut.ToolbarButtonCommand.Execute(true);
            sut.ToolbarButtonCommand.Execute(true);

            // Assert
            navServiceMock.Verify(n => n.NavigateToAsync<LoginViewModel>(It.IsAny<WeekPlannerViewModel>()));
        }

        [Xunit.Theory]
        [InlineData("Gem ændringer")]
        [InlineData("Gem ikke")]
        public void OnBackButtonPressedCommand_Executed_InvokesNavigationPopOnCorrectResult(string result)
        {
            // Arrange
            var dialogServiceMock = Fixture.Freeze<Mock<IDialogService>>()
                .Setup(d => d.ActionSheetAsync(PopupMessages.SavePromptTitle,
                    PopupMessages.Cancel, null, PopupMessages.SaveAndQuit, PopupMessages.QuitWithoutSave))
                .ReturnsAsync(result);
            var navServiceMock = Fixture.Freeze<Mock<INavigationService>>();
            var sut = Fixture.Create<WeekPlannerViewModel>();
            
            // Act
            sut.OnBackButtonPressedCommand.Execute(true);

            // Assert
            navServiceMock.Verify(n => n.PopAsync());
        }

        [Xunit.Theory]
        [InlineData(PopupMessages.Cancel)]
        [InlineData("Wrong string")]
        [InlineData("Gem ændringer_Partially correct")]
        public void OnBackButtonPressedCommand_Executed_CancelsOnIncorrectResult(string result)
        {
            // Arrange
            var dialogServiceMock = Fixture.Freeze<Mock<IDialogService>>()
                .Setup(d => d.ActionSheetAsync(PopupMessages.SavePromptTitle,
                    PopupMessages.Cancel, null, PopupMessages.SaveAndQuit, PopupMessages.QuitWithoutSave))
                .ReturnsAsync(result);
            var navServiceMock = Fixture.Freeze<Mock<INavigationService>>();
            var sut = Fixture.Create<WeekPlannerViewModel>();

            // Act
            sut.OnBackButtonPressedCommand.Execute(true);

            // Assert
            navServiceMock.Verify(n => n.PopAsync(), Times.Never);
        }
    }
}