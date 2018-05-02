using System;
using System.Diagnostics;
using System.Threading.Tasks;
using System.Windows.Input;
using IO.Swagger.Model;
using WeekPlanner.Services.Navigation;
using WeekPlanner.ViewModels.Base;
using Xamarin.Forms;
using WeekPlanner.Services;
using WeekPlanner.Views;

namespace WeekPlanner.ViewModels
{
    public class SavePromptViewModel : ViewModelBase
    {
        public readonly IDialogService _dialogService;

        public ICommand PromptPopupCommand => new Command(() => PromptPopup());
        public ICommand OnBackButtonPressedCommand => new Command(async () => await BackButtonPressed());

        public SavePromptViewModel(INavigationService navigationService, IDialogService dialogService) : base(navigationService)
        {
            _dialogService = dialogService;

        }


        private async void PromptPopup()
        {
            var result = await _dialogService.ActionSheetAsync("Title", "Annuller", null, "Hej1", "Hej2", "Hej3");
        }

        private async Task BackButtonPressed()
        {
            bool test = true;

            if (test)
            {
                var result = await _dialogService.ActionSheetAsync("Der er ændringer der ikke er gemt. Vil du gemme?", "Annuller", null, "Gem ændringer", "Gem ikke");

                switch (result)
                {
                    case "Annuller":
                        break;

                    case "Gem ændringer":
                        await NavigationService.PopAsync();
                        break;

                    case "Gem ikke":
                        await NavigationService.PopAsync();
                        break;
                }
            }
        }
    }
}
