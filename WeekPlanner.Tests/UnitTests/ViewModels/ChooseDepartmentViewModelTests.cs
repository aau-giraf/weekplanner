using AutoFixture;
using IO.Swagger.Model;
using System.Collections.ObjectModel;
using WeekPlanner.ViewModels;
using Xunit;
using Moq;
using IO.Swagger.Api;
using System.Linq;
using Xamarin.Forms;
using WeekPlanner.ViewModels.Base;
using IO.Swagger.Client;
using WeekPlanner.Services.Navigation;
using WeekPlanner.Services.Settings;
using WeekPlanner.Tests.UnitTests.Base;

namespace WeekPlanner.Tests.UnitTests.ViewModels
{
	public class ChooseDepartmentViewModelTests : TestsBase
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
				{
					invoked = true;
				}
			};

			// Act
			sut.Departments = new ObservableCollection<DepartmentNameDTO>();

			// Assert
			Assert.True(invoked);
		}

		[Fact]
		public async void InitializeAsync_SuccesfulResponse_DepartmentsPropertyIsNotNull()
		{
			// Arrange
			var departmentApiMock = Fixture.Freeze<Mock<IDepartmentApi>>();
			var departments = Fixture.CreateMany<DepartmentNameDTO>().ToList();

			var response = Fixture
				.Build<ResponseListDepartmentNameDTO>()
				.With(x => x.Success, true)
				.With(r => r.Data, departments)
				.Create();

			departmentApiMock
				.Setup(n => n.V1DepartmentNamesGetAsync())
				.ReturnsAsync(response);

			var sut = Fixture.Create<ChooseDepartmentViewModel>();

			// Act
			await sut.InitializeAsync(null);

			// Assert
			Assert.NotNull(sut.Departments);
		}

		[Fact]
		public async void InitializeAsync_ApiReturnsNotSuccessful_SendsErrorMessage()
		{
			// Arrange
			var response = Fixture
				.Build<ResponseListDepartmentNameDTO>()
				.With(x => x.Success, false)
				.Create();

			Fixture.Freeze<Mock<IDepartmentApi>>()
                   .Setup(n => n.V1DepartmentNamesGetAsync())
				.ReturnsAsync(response);

			bool errorWasSent = false;
			MessagingCenter.Subscribe<ChooseDepartmentViewModel, string>(this,
				MessageKeys.RequestFailed, (sender, msg) => errorWasSent = true);

			var sut = Fixture.Create<ChooseDepartmentViewModel>();

			// Act
			await sut.InitializeAsync(null);

			// Assert
			Assert.True(errorWasSent);
		}

		[Fact]
		public async void InitializeAsync_ApiThrowsError_SendsErrorMessage()
		{
			// Arrange
			Fixture.Freeze<Mock<IDepartmentApi>>()
				.Setup(n => n.V1DepartmentNamesGetAsync())
				.Throws(new ApiException());

			bool errorWasSent = false;
			MessagingCenter.Subscribe<ChooseDepartmentViewModel, string>(this,
				MessageKeys.RequestFailed, (sender, msg) => errorWasSent = true);

			var sut = Fixture.Create<ChooseDepartmentViewModel>();

			// Act
			await sut.InitializeAsync(null);

			// Assert
			Assert.True(errorWasSent);
		}

		[Fact]
		private void ChooseDepartmentCommand_Executed_SetsDepartmentIdInSettings()
		{
			// Assert
			var settingsServiceMock = Fixture.Freeze<Mock<ISettingsService>>();
			int departmentIdChosen = 5;
			var DepartmentNameDTO = Fixture.Build<DepartmentNameDTO>()
				.With(d => d.Id, departmentIdChosen)
				.Create();

			var sut = Fixture.Create<ChooseDepartmentViewModel>();


			// Act
			sut.ChooseDepartmentCommand.Execute(DepartmentNameDTO);

			// Assert
			settingsServiceMock.VerifySet(s => s.Department.Id = departmentIdChosen);
		}

		[Fact]
		private void ChooseDepartmentCommand_Executed_InvokesNavigateToLoginViewModel()
		{
			// Assert
			var navigationMock = Fixture.Freeze<Mock<INavigationService>>();
			var sut = Fixture.Create<ChooseDepartmentViewModel>();

			// Act
			sut.ChooseDepartmentCommand.Execute(Fixture.Create<DepartmentNameDTO>());

			// Assert
			navigationMock.Verify(x => x.NavigateToAsync<LoginViewModel>(null));
		}
	}
}
