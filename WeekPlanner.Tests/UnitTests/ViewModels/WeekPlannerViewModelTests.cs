using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
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
using WeekPlanner.ViewModels;
using Xunit;
using Assert = Xunit.Assert;

namespace WeekPlanner.Tests.UnitTests.ViewModels
{
<<<<<<< HEAD
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

			Func<WeekPlannerViewModel, Func<Task<ResponseWeekDTO>>, Func<ResponseWeekDTO, Task>, Func<Task>, Func<Task>,
					string, string, Task>
				sendRequestAndThenAsyncMock =
					async (sender, requestAsync, onSuccessAsync, onExceptionAsync, onRequestFailedAsync,
						exceptionMessage, requestFailedMessage) =>
					{
						var res = await requestAsync.Invoke();
						await onSuccessAsync(res);
					};
			var mockRequest = Fixture.Freeze<Mock<IRequestService>>().Setup(r =>
					r.SendRequestAndThenAsync(It.IsAny<WeekPlannerViewModel>(), It.IsAny<Func<Task<ResponseWeekDTO>>>(),
						It.IsAny<Func<ResponseWeekDTO, Task>>(), It.IsAny<Func<Task>>(), It.IsAny<Func<Task>>(),
						It.IsAny<string>(), It.IsAny<string>()))
				.Returns(sendRequestAndThenAsyncMock);

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
				response.Data.Days.FirstOrDefault(d => d.Day == day)?.Elements.Select(e => e.Id).Select(i => i.Value)
					.ToList();

			//Assert
			Assert.Equal(dayIdsFromWeek, dayIds);
		}

		[Fact]
		public async void CountOfMaxHeightWeekday_AfterInitAsync_returnsCorrectCount()
		{
			//Arrange
			var mockUsernameDTO = Fixture.Create<UserNameDTO>();

			Func<WeekPlannerViewModel, Func<Task<ResponseWeekDTO>>, Func<ResponseWeekDTO, Task>, Func<Task>, Func<Task>,
					string, string, Task>
				sendRequestAndThenAsyncMock =
					async (sender, requestAsync, onSuccessAsync, onExceptionAsync, onRequestFailedAsync,
						exceptionMessage, requestFailedMessage) =>
					{
						var res = await requestAsync.Invoke();
						await onSuccessAsync(res);
					};
			var mockRequest = Fixture.Freeze<Mock<IRequestService>>().Setup(r =>
					r.SendRequestAndThenAsync(It.IsAny<WeekPlannerViewModel>(), It.IsAny<Func<Task<ResponseWeekDTO>>>(),
						It.IsAny<Func<ResponseWeekDTO, Task>>(), It.IsAny<Func<Task>>(), It.IsAny<Func<Task>>(),
						It.IsAny<string>(), It.IsAny<string>()))
				.Returns(sendRequestAndThenAsyncMock);

			async Task LoginAndThenMock(Func<Task> onSuccess, UserType userType, string username, string password) =>
				await onSuccess.Invoke();

			var mockLogin = Fixture.Freeze<Mock<ILoginService>>().Setup(l =>
					l.LoginAndThenAsync(It.IsAny<Func<Task>>(), UserType.Citizen, mockUsernameDTO.UserName, ""))
				.Returns((Func<Func<Task>, UserType, string, string, Task>)LoginAndThenMock);

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
			Assert.Equal(weekResponse.Data.Days.Max(d => d.Elements.Count), sut.CountOfMaxHeightWeekday);
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
=======
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

            Func<WeekPlannerViewModel, Func<Task<ResponseWeekDTO>>, Func<ResponseWeekDTO, Task>, Func<Task>, Func<Task>,
                    string, string, Task>
                sendRequestAndThenAsyncMock =
                    async (sender, requestAsync, onSuccessAsync, onExceptionAsync, onRequestFailedAsync,
                        exceptionMessage, requestFailedMessage) =>
                    {
                        var res = await requestAsync.Invoke();
                        await onSuccessAsync(res);
                    };
            var mockRequest = Fixture.Freeze<Mock<IRequestService>>().Setup(r =>
                    r.SendRequestAndThenAsync(It.IsAny<WeekPlannerViewModel>(), It.IsAny<Func<Task<ResponseWeekDTO>>>(),
                        It.IsAny<Func<ResponseWeekDTO, Task>>(), It.IsAny<Func<Task>>(), It.IsAny<Func<Task>>(),
                        It.IsAny<string>(), It.IsAny<string>()))
                .Returns(sendRequestAndThenAsyncMock);

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
                response.Data.Days.FirstOrDefault(d => d.Day == day)?.Elements.Select(e => e.Id).Select(i => i.Value)
                    .ToList();

            //Assert
            Assert.Equal(dayIdsFromWeek, dayIds);
        }

        [Fact]
        public async void CountOfMaxHeightWeekday_AfterInitAsync_returnsCorrectCount()
        {
            //Arrange
            var mockUsernameDTO = Fixture.Create<UserNameDTO>();

            Func<WeekPlannerViewModel, Func<Task<ResponseWeekDTO>>, Func<ResponseWeekDTO, Task>, Func<Task>, Func<Task>,
                    string, string, Task>
                sendRequestAndThenAsyncMock =
                    async (sender, requestAsync, onSuccessAsync, onExceptionAsync, onRequestFailedAsync,
                        exceptionMessage, requestFailedMessage) =>
                    {
                        var res = await requestAsync.Invoke();
                        await onSuccessAsync(res);
                    };
            var mockRequest = Fixture.Freeze<Mock<IRequestService>>().Setup(r =>
                    r.SendRequestAndThenAsync(It.IsAny<WeekPlannerViewModel>(), It.IsAny<Func<Task<ResponseWeekDTO>>>(),
                        It.IsAny<Func<ResponseWeekDTO, Task>>(), It.IsAny<Func<Task>>(), It.IsAny<Func<Task>>(),
                        It.IsAny<string>(), It.IsAny<string>()))
                .Returns(sendRequestAndThenAsyncMock);

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
            Assert.Equal(weekResponse.Data.Days.Max(d => d.Elements.Count), sut.CountOfMaxHeightWeekday);
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
        [Theory]
        [InlineData(DayOfWeek.Monday)]
        [InlineData(DayOfWeek.Tuesday)]
        [InlineData(DayOfWeek.Wednesday)]
        [InlineData(DayOfWeek.Thursday)]
        [InlineData(DayOfWeek.Friday)]
        [InlineData(DayOfWeek.Saturday)]
        [InlineData(DayOfWeek.Sunday)]
        public async Task WeekdayPictos_Highligt_FirstNormalPicto_OfCurrentDay(DayOfWeek weekday)
        {
            // Arrange
            var dateTimeConverter = new WeekPlannerViewModel.DateTimeConverter();
            var mockUsernameDTO = Fixture.Create<UserNameDTO>();
            async Task LoginAndThenMock(Func<Task> onSuccess, UserType userType, string username, string password) =>
                await onSuccess.Invoke();
            var mockLogin = Fixture.Freeze<Mock<ILoginService>>().Setup(l =>
                    l.LoginAndThenAsync(It.IsAny<Func<Task>>(), UserType.Citizen, mockUsernameDTO.UserName, ""))
                .Returns((Func<Func<Task>, UserType, string, string, Task>)LoginAndThenMock);
            var weekResponse = Fixture.Build<ResponseWeekDTO>()
                .With(r => r.Success, true)
                .With(r => r.ErrorKey, ResponseWeekDTO.ErrorKeyEnum.NoError)
                .With(r => r.Data, Fixture.Create<WeekDTO>()).Create();
            var mockWeek = Fixture.Freeze<Mock<IWeekApi>>()
                .Setup(w => w.V1WeekByIdGetAsync(It.IsAny<long?>()))
                .ReturnsAsync(weekResponse);
            var sut = Fixture.Build<WeekPlannerViewModel>().OmitAutoProperties().Create();
            // Act
            await sut.InitializeAsync(mockUsernameDTO);
            // Find the first pictogram, that are: normal state and first.
            var borderedPicto = Fixture.Create<StatefulPictogram>();
            sut.SetBorderStatusPictograms(weekday);
            foreach (var weekDayPicto in sut.WeekdayPictos)
            {
                if (weekDayPicto.Key == dateTimeConverter.GetWeekDay(weekday))
                {
                    borderedPicto.Border = weekDayPicto.Value.Where((s) => s.PictogramState == PictogramState.Normal).First().Border;
                    return;
                }
            }
            //Assert
            Assert.Equal("Black", borderedPicto.Border);
        }
    }
>>>>>>> 1fba5a6944580e4ba5e48305c0cc207095ad5fbc
}