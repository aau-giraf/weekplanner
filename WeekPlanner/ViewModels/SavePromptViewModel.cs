using System;
using System.Diagnostics;
using System.Threading.Tasks;
using System.Windows.Input;
using IO.Swagger.Model;
using WeekPlanner.Services.Navigation;
using WeekPlanner.ViewModels.Base;
using Xamarin.Forms;

namespace WeekPlanner.ViewModels
{
    public class SavePromptViewModel : ViewModelBase
    {
        public ICommand PromptPopupCommand => new Command(() => PromptPopup());

        public SavePromptViewModel(INavigationService navigationService) : base(navigationService)
        {

        }


        private async Task PromptPopup()
        {
            MessagingCenter.Send(this, MessageKeys.ScheduleNotSavedPrompt);
        }
    }
}
