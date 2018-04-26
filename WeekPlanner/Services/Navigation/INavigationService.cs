using System.Threading.Tasks;
using WeekPlanner.ViewModels.Base;

namespace WeekPlanner.Services.Navigation
{
    public interface INavigationService
    {
        ViewModelBase PreviousPageViewModel { get; }

        Task InitializeAsync();

        Task PopAsync(object navidationData = null);

        Task NavigateToAsync<TViewModel>(object parameter = null) where TViewModel : ViewModelBase;

        Task RemoveLastFromBackStackAsync();

        Task RemoveBackStackAsync();
    }
}
