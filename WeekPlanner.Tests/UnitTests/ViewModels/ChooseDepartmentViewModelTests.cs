using AutoFixture;
using IO.Swagger.Model;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Text;
using WeekPlanner.ViewModels;
using Xunit;
using Moq;

namespace WeekPlanner.Tests.UnitTests.ViewModels
{
    public class ChooseDepartmentViewModelTests : ViewModelTestsBase
    {
        [Fact]
        public void DepartmentsProperty_OnSet_RaisePropertyChanged()
        {
            // Arrange
            var sut = Fixture.Create<ChooseDepartmentViewModel>();

            bool invoked = false;
            sut.PropertyChanged += (sender, e) =>
            {
                if (e.PropertyName.Equals(nameof(sut.Departments)))
                    invoked = true;
            };
            // Act
            sut.Departments = new ObservableCollection<DepartmentDTO>();

            // Assert
            Assert.True(invoked);
        }

        [Fact]
        public async void ListNotEmpty_After_Initializing()
        {
            // Arrange
            var sut = Fixture.Create<ChooseDepartmentViewModel>();

            // Moq _departmentApi.V1DepartmentGetAsync so it returns a success response with a list of departments

            // Act
            await sut.InitializeAsync(null);

            // Assert
            Assert.True(sut.Departments.Count > 0);
        }

        [Fact]
        public async void SendsError_When_ResponseNotSuccessful()
        {
            // Arrange
            var sut = Fixture.Create<ChooseDepartmentViewModel>();
            bool errorWasSent = false;

            // Act
            await sut.InitializeAsync(null);

            // Assert
            Assert.True(errorWasSent);
        }

        [Fact]
        public async void SendsError_When_ResponseThrowsApiException()
        {
            // Arrange
            var sut = Fixture.Create<ChooseDepartmentViewModel>();
            bool errorWasSent = false;

            // Act
            await sut.InitializeAsync(null);

            // Assert
            Assert.True(errorWasSent);
        }
    }
}
