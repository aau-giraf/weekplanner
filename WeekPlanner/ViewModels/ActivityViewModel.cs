using System;
using System.Threading.Tasks;
using WeekPlanner.Services.Navigation;
using WeekPlanner.ViewModels.Base;
using Xamarin.Forms;

namespace WeekPlanner.ViewModels
{
    public class ActivityViewModel : ViewModelBase
    {
        private ImageSource _imageSource;

        public ActivityViewModel(INavigationService navigationService) : base(navigationService)
        {

        }

        override public async Task InitializeAsync(object navigationData)
        {
            if (navigationData is ImageSource imgSource)
            {
                ImageSource = imgSource;
            }
        }

        public ImageSource ImageSource
        {
            get => _imageSource; 
            set
            {
                _imageSource = value;
                RaisePropertyChanged(() => ImageSource);
            }
        }
        public string Hello { get; set; } = "The One";
    }
}