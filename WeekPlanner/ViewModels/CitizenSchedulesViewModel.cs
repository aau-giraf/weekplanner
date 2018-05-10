using IO.Swagger.Api;
using IO.Swagger.Model;
using System;
using System.Linq;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Input;
using WeekPlanner.Services.Login;
using WeekPlanner.Services.Navigation;
using WeekPlanner.Services.Request;
using WeekPlanner.ViewModels.Base;
using Xamarin.Forms;
using WeekPlanner.Services.Settings;
using WeekPlanner.Views;
using WeekPlanner.Services;
using WeekPlanner.Helpers;
using Xamarin.Forms;

namespace WeekPlanner.ViewModels
{
    public class CitizenSchedulesViewModel : ViewModelBase
    {
        private readonly IRequestService _requestService;
        private readonly IDialogService _dialogService;
        private readonly IWeekApi _weekApi;
        private readonly ILoginService _loginService;
        private readonly ISettingsService _settingsService;

        public ICommand WeekTappedCommand => new Command<WeekDTO>(ListViewItemTapped);
        public ICommand WeekDeletedCommand => new Command<WeekDTO>(async week => await WeekDeletedTapped(week));
        
        // Create new weekschedule button in toolbar
        public ICommand ToolbarButtonCommand => new Command(async () => await AddWeekSchedule());
        public bool ShowToolbarButton => true;
        public ImageSource ToolbarButtonIcon => (FileImageSource)ImageSource.FromFile("icon_add.png");

        public CitizenSchedulesViewModel(INavigationService navigationService, IRequestService requestService,
            IDialogService dialogService, IWeekApi weekApi, ILoginService loginService,
            ISettingsService settingsService) : base(navigationService)
        {
            _requestService = requestService;
            _dialogService = dialogService;
            _weekApi = weekApi;
            _loginService = loginService;
            _settingsService = settingsService;
        }

        private ObservableCollection<WeekNameDTO> _weekNameDtos = new ObservableCollection<WeekNameDTO>();

        public ObservableCollection<WeekNameDTO> WeekNameDTOS
        {
            get => _weekNameDtos;
            set
            {
                _weekNameDtos = value;
                RaisePropertyChanged(() => WeekNameDTOS);
            }
        }

        private ObservableCollection<WeekDTO> _weeks = new ObservableCollection<WeekDTO>();

        public ObservableCollection<WeekDTO> Weeks
        {
            get => _weeks;
            set
            {
                _weeks = value;
                RaisePropertyChanged(() => Weeks);
            }
        }

        private async void ListViewItemTapped(WeekDTO tappedItem)
        {
            if (IsBusy) return;

            IsBusy = true;
            await NavigationService.NavigateToAsync<WeekPlannerViewModel>(new Tuple<int?, int?>(tappedItem.WeekYear,
                tappedItem.WeekNumber));
            IsBusy = false;
        }

        public async Task InitializeWeekSchedules()
        {
            await _requestService.SendRequestAndThenAsync(
                requestAsync: () => _weekApi.V1WeekGetAsync(),
                onSuccess: result => { WeekNameDTOS = new ObservableCollection<WeekNameDTO>(result.Data); },
                onRequestFailedAsync: () => Task.FromResult("'No week schedules found is not an error'-fix."));

            foreach (var item in WeekNameDTOS)
            {
                await _requestService.SendRequestAndThenAsync(
                    () => _weekApi.V1WeekByWeekYearByWeekNumberGetAsync(weekYear: item.WeekYear,
                        weekNumber: item.WeekNumber), (res) => Weeks.Add(res.Data));
            }
        }

        private async Task WeekDeletedTapped(WeekDTO week)
        {
            if (IsBusy) return;
            IsBusy = true;

            if (week is WeekDTO weekDTO)
            {
                await DeleteWeek(weekDTO);
            }

            IsBusy = false;
        }

        private async Task DeleteWeek(WeekDTO week)
        {
            var confirmed = await _dialogService.ConfirmAsync($"Vil du slette {week.Name}?", "Slet Ugeplan");
            if (!confirmed)
            {
                return;
            }

            await _requestService.SendRequestAndThenAsync(
                requestAsync: () =>
                    _weekApi.V1WeekByWeekYearByWeekNumberDeleteAsync(weekNumber: week.WeekNumber,
                        weekYear: week.WeekYear), onSuccess: (r) => Weeks.Remove(week));
        }

        private async Task AddWeekSchedule()
        {
            if (IsBusy) return;

            IsBusy = true;
            await NavigationService.NavigateToAsync<NewScheduleViewModel>();
            IsBusy = false;
        }

        public override async Task PoppedAsync(object navigationData)
        {
            Weeks.Clear();
            WeekNameDTOS.Clear();
            _settingsService.UseTokenFor(UserType.Citizen);
            await InitializeWeekSchedules();
        }

        public override async Task InitializeAsync(object navigationData)
        {
            if (navigationData is UserNameDTO userNameDTO)
            {
                await _loginService.LoginAndThenAsync(UserType.Citizen, userNameDTO.UserName, "", InitializeWeekSchedules);
            }
            else
            {
                throw new ArgumentException("Must be of type userNameDTO", nameof(navigationData));
            }
        }
    }
}