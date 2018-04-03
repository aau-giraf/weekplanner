using System.Collections.Generic;
using System.Collections.ObjectModel;
using AutoFixture;
using IO.Swagger.Api;
using IO.Swagger.Client;
using IO.Swagger.Model;
using Moq;
using WeekPlanner.Services.Navigation;
using WeekPlanner.Services.Settings;
using WeekPlanner.ViewModels;
using WeekPlanner.ViewModels.Base;
using Xamarin.Forms;
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
        void WeekdayPictosProperties_ReturnsCorrectPictos()
        {
            //Arrange
            var sut = Fixture.Create<WeekPlannerViewModel>();
            //Act
            //Assert
        }
        
        [Fact]
        public void WeekdayPictos_AfterInitAsync_IsNotNull()
        {
            //Arrange
            
            
            //Act
            
            //Assert
            
        }
        
    }
}