using System.Windows.Input;
using WeekPlanner.ViewModels.Base;
using Xamarin.Forms;

namespace WeekPlanner.ViewModels
{
    public class TestingViewModel : ViewModelBase
    {
        public TestingViewModel()
        {
            Title = "Giraf";
        }
        
        public ICommand NavigateToLoginCommand =>
            new Command(async () => await NavigationService.NavigateToAsync<LoginViewModel>());
    }
}