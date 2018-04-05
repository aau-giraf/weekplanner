using System;
using Xunit;
using AutoFixture;
using Moq;
using WeekPlanner.ViewModels;
using WeekPlanner.ViewModels.Base;
using System.Collections.ObjectModel;
using Xamarin.Forms;
using IO.Swagger.Model;
using System.Collections.Generic;
using WeekPlanner.Services.Navigation;

namespace WeekPlanner.Tests.ViewModels
{
    public class WeekPlannerViewModelTests : UnitTests.ViewModels.ViewModelTestsBase
    {
        public WeekPlannerViewModelTests()
        {
        }

        [Theory]
        public void EditModeEnabled_UnToggle_VariableChanched()
        {
            //Arrange
            var sut = Fixture.Create<WeekPlannerViewModel>();
            sut.EditModeEnabled = true;

            bool result = false;

            //Act
            sut.ToggleEditModeCommand = result;

            //Assert
        }
    }

}
