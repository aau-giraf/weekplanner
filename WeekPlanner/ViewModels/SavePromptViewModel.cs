using System;
using System.Diagnostics;
using System.Threading.Tasks;
using System.Windows.Input;
using IO.Swagger.Model;
using WeekPlanner.Services.Navigation;
using WeekPlanner.ViewModels.Base;
using Xamarin.Forms;
using WeekPlanner.Services;

namespace WeekPlanner.ViewModels
{
    public class SavePromptViewModel : ViewModelBase
    {
        public readonly IDialogService _dialogService;

        public ICommand PromptPopupCommand => new Command(() => PromptPopup());

        public SavePromptViewModel(INavigationService navigationService, IDialogService dialogService) : base(navigationService)
        {
            _dialogService = dialogService;
        }


        private async void PromptPopup()
        {
            var result = await _dialogService.ActionSheetAsync("Title", "Annuller", null, "Hej1", "Hej2", "Hej3");

            
        }
    }
}
