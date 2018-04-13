using WeekPlanner.Services.Navigation;
using WeekPlanner.ViewModels.Base;

namespace WeekPlanner.ViewModels
{
    public class ActivityViewModel : ViewModelBase
    {
        public ActivityViewModel(INavigationService navigationService) : base(navigationService)
        {
            
        }

        public string Hello { get; set; } = "The One";
    }
}