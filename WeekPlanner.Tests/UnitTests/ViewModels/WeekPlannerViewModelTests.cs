using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using AutoFixture;
using IO.Swagger.Model;
using Moq;
using Syncfusion.ListView.XForms;
using WeekPlanner.Services.Navigation;
using WeekPlanner.Services;
using WeekPlanner.ViewModels;
using Xunit;
using Assert = Xunit.Assert;
using WeekPlanner.ViewModels.Base;

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
            //sut.WeekdayPictos = new Dictionary<WeekdayDTO.DayEnum, ObservableCollection<string>>();

            //Assert
            Assert.True(invoked);
        }

        [Theory]
        [InlineData(WeekdayDTO.DayEnum.Monday)]
        [InlineData(WeekdayDTO.DayEnum.Tuesday)]
        [InlineData(WeekdayDTO.DayEnum.Wednesday)]
        [InlineData(WeekdayDTO.DayEnum.Thursday)]
        [InlineData(WeekdayDTO.DayEnum.Friday)]
        [InlineData(WeekdayDTO.DayEnum.Saturday)]
        [InlineData(WeekdayDTO.DayEnum.Sunday)]
        public async Task DayPictosProperty_AfterInitAsync_ReturnsCorrectPictos(WeekdayDTO.DayEnum day)
        {
            /*//Arrange
            var usernameDTO = Fixture.Create<UserNameDTO>();
            Func<Func<Task>, UserType, string, string, Task> loginAndThenMock =
                async (onSuccess, userType, username, password) => await onSuccess.Invoke();

            FreezeMockOfIRequestService<WeekPlannerViewModel, ResponseWeekDTO>();
            
            var mockLogin = Fixture.Freeze<Mock<ILoginService>>().Setup(l =>
                    l.LoginAndThenAsync(UserType.Citizen, usernameDTO.UserName, "", It.IsAny<Func<Task>>()))
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
            Assert.Equal(dayIdsFromWeek, dayIds);*/
        }

        [Fact]
        public async Task WeekdayPictos_AfterInitAsync_IsNotNullAsync()
        {
             //Arrange
            /*var weekResponse = Fixture.Build<ResponseWeekDTO>()
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
            Assert.NotNull(sut.WeekdayPictos);*/
        }

        [Fact]
        public void EditModeProperty_OnChange_RaisePropertyChanged()
        {
            //Arrange
            var sut = Fixture.Create<WeekPlannerViewModel>();

            bool invoked = false;
            sut.PropertyChanged += (sender, e) =>
            {
                if (e.PropertyName.Equals(nameof(sut.SettingsService.IsInGuardianMode)))
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

        #region BackButtonPressed
        
        [Theory]
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
            navServiceMock.Verify(n => n.PopAsync(null));
        }

        [Theory]
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
            navServiceMock.Verify(n => n.PopAsync(null), Times.Never);
        }       

        #endregion
        
        #region Drag and Drop

        [Theory]
        [InlineData(0, 3)]
        public void PictoDraggedCommand_AfterInvoke_ActivityOrdersSetCorrectly(int oldIndex, int newIndex)
        {
            // Arrange
            
            // Make AutoFixture create newindex + 1 items when using CreateMany
            Fixture.RepeatCount = newIndex + 1;
            var activities = Fixture.CreateMany<ActivityDTO>().ToList();
            var order = 0;
            activities.ForEach(a => a.Order = order++);

            var days = Enum.GetValues(typeof(WeekdayDTO.DayEnum)).Cast<WeekdayDTO.DayEnum>()
                .Select(d => Fixture.Build<WeekdayDTO>()
                    .With(w => w.Day, d).Create()).ToList();

            var dayMovedIn = days.Find(d => d.Day == WeekdayDTO.DayEnum.Monday);

            dayMovedIn.Activities = activities;

            var weekDTO = Fixture.Build<WeekDTO>()
                .With(w => w.Days, days)
                .Create();
            
            var sut = Fixture.Build<WeekPlannerViewModel>()
                .With(w => w.WeekDTO, weekDTO)
                .Create();

            var activityMoved = dayMovedIn.Activities[oldIndex];

            // Cannot mock this with Moq. R.I.P.
            var eventArgsMock = new Mock<ItemDraggingEventArgs>();
            eventArgsMock.Setup(e => e.Action).Returns(DragAction.Drop);
            eventArgsMock.Setup(e => e.OldIndex).Returns(oldIndex);
            eventArgsMock.Setup(e => e.NewIndex).Returns(newIndex);
            eventArgsMock.Setup(e => e.ItemData).Returns(activityMoved);

            var oldPositions = activities.Select(a => ((long) a.Id, (int) a.Order));
                
            // Act
            sut.ActivityDraggedCommand.Execute(fakeArgs);
            
            // Assert
            var lowestIndexAffected = Math.Min(oldIndex, newIndex);
            var highestIndexAffected = Math.Max(oldIndex, newIndex);
            
            Assert.Equal(newIndex, activityMoved.Order);
        }

        #endregion
        
        #region helpers
        
        private List<ActivityDTO> CreateActivityDtos(int count, List<int> orders = null)
        {
            if (count <= 0)
            {
                throw new ArgumentException("Should be a positive integer.", nameof(count));
            }
            
            var activities = new List<ActivityDTO>();
            if (orders != null)
            {
                activities.AddRange(orders.Select((t, i) => Fixture.Build<ActivityDTO>()
                    .With(a => a.Id, i)
                    .With(a => a.Order, t)
                    .Create()));
            }
            else
            {
                for (int i = 0; i < count; i++)
                {
                    var activity = Fixture.Build<ActivityDTO>()
                        .With(a => a.Id, i)
                        .With(a => a.Order, i)
                        .Create();
                    activities.Add(activity);
                }
            }

            return activities;
        }

        private WeekDTO CreateWeekDTO(int activitiesPerDay)
        {
            var weekdays = new List<WeekdayDTO>();
            foreach (WeekdayDTO.DayEnum d in Enum.GetValues(typeof(WeekdayDTO.DayEnum)))
            {
                var weekdayDTO = Fixture.Build<WeekdayDTO>()
                    .With(w => w.Day, d)
                    .With(w => w.Activities, CreateActivityDtos(activitiesPerDay, new List<int>()))
                    .Create();
                weekdays.Add(weekdayDTO);
            }

            return Fixture.Build<WeekDTO>()
                .With(w => w.Days, weekdays).Create();
        }

        

        #endregion
    }
}
