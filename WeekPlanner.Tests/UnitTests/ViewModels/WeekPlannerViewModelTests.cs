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
using NUnit.Framework;
using WeekPlanner.Services.Login;
using WeekPlanner.Services.Settings;
using WeekPlanner.ViewModels;
using Xamarin.Forms;
using Xunit;
using Assert = Xunit.Assert;

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

            var dayIds = sut.WeekdayPictos[day].Select(p =>
                    Convert.ToInt64(Regex.Match(p.ToString(), "pictogram/(.*)/image").Groups[1].Value))
                .ToList();

            var dayIdsFromWeek =
                response.Data.Days.FirstOrDefault(d => d.Day == day)?.ElementIDs.Select(i => i.Value).ToList();

            //Assert
            CollectionAssert.AreEqual(dayIdsFromWeek, dayIds);
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
    }
}