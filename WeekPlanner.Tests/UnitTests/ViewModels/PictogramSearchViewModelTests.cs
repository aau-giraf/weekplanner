using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using AutoFixture;
using IO.Swagger.Api;
using IO.Swagger.Model;
using Moq;
using WeekPlanner.Services.Navigation;
using WeekPlanner.ViewModels;
using WeekPlanner.ViewModels.Base;
using Xamarin.Forms;
using Xunit;

namespace WeekPlanner.Tests.UnitTests.ViewModels
{
    public class PictogramSearchViewModelTests : ViewModelTestsBase
    {
        // FuncNavn_Conditions_Result
        [Fact]
        public void ItemTappedCommand_Executed_SendsMessage()
        {
            // Arrange
            var messageReceived = false;
            MessagingCenter.Subscribe<PictogramSearchViewModel, PictogramDTO>(this, MessageKeys.PictoSearchChosenItem,
                (sender, args) => messageReceived = true);
            var pictogramDTO = Fixture.Create<PictogramDTO>();
            
            var sut = Fixture.Create<PictogramSearchViewModel>();
            
            // Act
            sut.ItemTappedCommand.Execute(pictogramDTO);
            
            // Assert
            Assert.True(messageReceived);
        }

        [Fact]
        public void ItemTappedCommand_Executed_InvokesNavigationPop()
        {
            
            // Arrange
            var navServiceMock = Fixture.Freeze<Mock<INavigationService>>();
            var pictogramDTO = Fixture.Create<PictogramDTO>();
            var sut = Fixture.Create<PictogramSearchViewModel>();
            
            // Act
            sut.ItemTappedCommand.Execute(pictogramDTO);
            
            // Assert
            navServiceMock.Verify(n => n.PopAsync(), Times.Once);
        }

        [Fact]
        public void ImageSource_OnSet_PropertyOnChanged()
        {
            // Arrange
            var SystemUnderTesting = Fixture.Create<PictogramSearchViewModel>();
            bool PropertyOnChangedIsInvoked = false;

            SystemUnderTesting.PropertyChanged += (sender, e) =>
            {
                if (e.PropertyName.Equals(nameof(SystemUnderTesting.ImageSources)))
                    PropertyOnChangedIsInvoked = true;
            };
            // Act
            SystemUnderTesting.ImageSources = new ObservableCollection<PictogramDTO>();

            // Assert
            Assert.True(PropertyOnChangedIsInvoked);
        }

        [Fact]
        public void ImageSource_OnSet_Size()
        {
            // Arrange
            var pictograms = Fixture.Create<List<PictogramDTO>>();
            var response = Fixture.Build<ResponseListPictogramDTO>()
                                  .With(r => r.Data, pictograms)
                                  .Create();

            var api = Fixture.Freeze<Mock<IPictogramApi>>()
                             .Setup(a => a.V1PictogramGet(It.IsAny<int?>(), It.IsAny<int?>(), It.IsAny<string>()))
                             .Returns(response);
            var SystemUnderTest = Fixture.Create<PictogramSearchViewModel>();             
            //var PictogramDTO = Fixture.Create<PictogramDTO>();             
            // Act             
            SystemUnderTest.OnSearchGetPictograms("kat");             
            // Assert             
            Assert.Equal(pictograms.Count, SystemUnderTest.ImageSources.Count);
        }

        [Fact] 
        public void ImageSource_OnSet_ApiFailure()
        {
            
        }
    }
}