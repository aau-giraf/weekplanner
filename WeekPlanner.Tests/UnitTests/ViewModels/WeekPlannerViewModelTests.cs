using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Globalization;
using System.Linq;
using System.Text.RegularExpressions;
using AutoFixture;
using AutoFixture.AutoMoq;
using IO.Swagger.Api;
using IO.Swagger.Client;
using IO.Swagger.Model;
using Moq;
using WeekPlanner.Services.Mocks;
using WeekPlanner.Services.Navigation;
using WeekPlanner.Services.Settings;
using WeekPlanner.ViewModels;
using WeekPlanner.ViewModels.Base;
using Xamarin.Forms;
using Xamarin.Forms.Internals;
using Xunit;
namespace WeekPlanner.Tests.UnitTests.ViewModels
{
    public class WeekPlannerViewModelTests : ViewModelTestsBase
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
            sut.WeekdayPictos = new Dictionary<WeekdayDTO.DayEnum, IEnumerable<ImageSource>>();
            
            //Assert
            Assert.True(invoked);
        }
        [Fact]
        public void MondayPictosProperty_AfterInitAsync_ReturnsCorrectPictos()
        {
            //Arrange

            var response = Fixture.Build<ResponseWeekDTO>()
                .With(r => r.Data, Fixture.Create<WeekDTO>())
                .With(r => r.Success, true)
                .With(r => r.ErrorKey, ResponseWeekDTO.ErrorKeyEnum.NoError)
                .Create();
            var mockWeek = Fixture.Freeze<Mock<IWeekApi>>()
                .Setup(w => w.V1WeekByIdGetAsync(It.IsAny<long?>()))
                .ReturnsAsync(response);

            var responsePictoRes = new ResponsePictogramDTO()
            {
                Success = true,
                ErrorKey = ResponsePictogramDTO.ErrorKeyEnum.NoError,
                Data = new PictogramDTO(Title:"asd")
                {
                    Id = 2
                }
            };
            var mockPicto = Fixture.Freeze<Mock<IPictogramApi>>()
                .Setup(w => w.V1PictogramByIdGetAsync(It.IsIn(response.Data.Days[0].ElementIDs.ToArray())))
                .ReturnsAsync(responsePictoRes);
            
            var sut = Fixture.Build<WeekPlannerViewModel>().OmitAutoProperties().Create();
            //Act
            sut.InitializeAsync(null);
            
            var mondayIds =
                sut.MondayPictos.Select(p => Convert.ToInt64(Regex.Match(p.ToString(), "{(.*)}").Groups[1].Value))
                    .ToList();
            
            var mondayIdsFromWeek = response.Data.Days[0].ElementIDs.Select(i => i.Value).ToList();
            //Assert
            Assert.Equal(mondayIdsFromWeek, mondayIds);
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
            
             var mockPicto = Fixture.Freeze<Mock<IPictogramApi>>()
                .Setup(w => w.V1PictogramByIdGetAsync(It.IsAny<long?>()))
                .ReturnsAsync(pictoResponse);

            var sut = Fixture.Build<WeekPlannerViewModel>().OmitAutoProperties().Create();
            //Act
            sut.InitializeAsync(null);
            //Assert
            Assert.NotNull(sut.WeekdayPictos);
        }

        [Fact]
        public void CountOfMaxHeightWeekday_AfterInitAsync_returnsCorrectCount()
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
            
             var mockPicto = Fixture.Freeze<Mock<IPictogramApi>>()
                .Setup(w => w.V1PictogramByIdGetAsync(It.IsAny<long?>()))
                .ReturnsAsync(pictoResponse);
            //Act 
            var sut = Fixture.Build<WeekPlannerViewModel>().OmitAutoProperties().Create();
            //Assert
            Assert.Equal(sut.CountOfMaxHeightWeekday, weekResponse.Data.Days.Max(d => d.ElementIDs.Count));
        }
        
    }
}