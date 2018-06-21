using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Threading.Tasks;
using AutoFixture;
using IO.Swagger.Api;
using IO.Swagger.Client;
using IO.Swagger.Model;
using Moq;
using WeekPlanner.Services.Navigation;
using WeekPlanner.ViewModels;
using WeekPlanner.ViewModels.Base;
using Xamarin.Forms;
using Xunit;

namespace WeekPlanner.Tests.UnitTests.ViewModels
{
    public class PictogramSearchViewModelTests : Base.TestsBase
    {
        // FuncNavn_Conditions_Result

        [Fact]
        public void ItemTappedCommand_Executed_InvokesNavigationPop()
        {
            
            // Arrange
            var navServiceMock = Fixture.Freeze<Mock<INavigationService>>();
            var weekPictogramDTO = Fixture.Create<WeekPictogramDTO>();
            var sut = Fixture.Build<PictogramSearchViewModel>()
                .OmitAutoProperties()
                .Create();
            
            // Act
            sut.ItemTappedCommand.Execute(weekPictogramDTO);
            
            // Assert
            navServiceMock.Verify(n => n.PopAsync(weekPictogramDTO), Times.Once);
        }

        [Fact]
        public void ImageSource_OnSet_PropertyOnChanged()
        {
            // Arrange
            var sut = Fixture.Create<PictogramSearchViewModel>();
            bool PropertyOnChangedIsInvoked = false;

            sut.PropertyChanged += (sender, e) =>
            {
                if (e.PropertyName.Equals(nameof(sut.ImageSources)))
                    PropertyOnChangedIsInvoked = true;
            };
            // Act
            sut.ImageSources = new ObservableCollection<WeekPictogramDTO>();

            // Assert
            Assert.True(PropertyOnChangedIsInvoked);
        }

        /*[Fact]
        public void ImageSource_OnSet_Size()
        {
            // Arrange
            var pictograms = Fixture.Create<List<PictogramDTO>>();
            var response = Fixture.Build<ResponseListWeekPictogramDTO>()
                                  .With(r => r.Data, pictograms)
                                  .Create();

            var api = Fixture.Freeze<Mock<IPictogramApi>>()
                             .Setup(a => a.V1PictogramGet(It.IsAny<int?>(), It.IsAny<int?>(), It.IsAny<string>()))
                             .Returns(response);
            var sut = Fixture.Create<PictogramSearchViewModel>();             
            //var PictogramDTO = Fixture.Create<PictogramDTO>();             
            // Act             
            sut.OnSearchGetPictograms("kat");             
            // Assert             
            Assert.Equal(pictograms.Count, sut.ImageSources.Count);
        }*/

    }
}