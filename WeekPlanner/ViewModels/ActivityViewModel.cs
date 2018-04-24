using System;
using System.Threading.Tasks;
using System.Windows.Input;
using IO.Swagger.Model;
using WeekPlanner.Services.Navigation;
using WeekPlanner.ViewModels.Base;
using Xamarin.Forms;

namespace WeekPlanner.ViewModels
{
    public class ActivityViewModel : ViewModelBase
    {
        private ActivityDTO _activity;
        private bool _isGuardianMode = true;

        public ActivityViewModel(INavigationService navigationService) : base(navigationService)
        {
            //MessagingCenter.Subscribe<PictogramSearchViewModel, PictogramDTO>(this, MessageKeys.PictoSearchChosenItem,
                //ChangePicto);
        }

        override public async Task InitializeAsync(object navigationData)
        {
            if (navigationData is ActivityDTO activity)
            {
                Activity = activity;
            }
        }

        public ActivityDTO Activity
        {
            get => _activity;
            set
            {
                _activity = value;
                RaisePropertyChanged(() => Activity);
            }
        }

        public ICommand ChangePictoCommand => new Command(async () =>
        {
            await NavigationService.NavigateToAsync<PictogramSearchViewModel>();
        });

        public ICommand DeleteActivityCommand => new Command(async () =>
        {
            // TODO: send message delete with resource.Id
            int activityID = 42;
            MessagingCenter.Send(this, MessageKeys.DeleteActivity, activityID);
            await NavigationService.PopAsync();
        });

        private void ChangePicto(PictogramDTO pictogramDTO)
        {
            Activity.Pictogram = pictogramDTO;
        }

        public bool IsGuardianMode { 
            get => _isGuardianMode; 
            set {
                _isGuardianMode = value;
                RaisePropertyChanged(() => IsGuardianMode);
            } 
        }
    }
}