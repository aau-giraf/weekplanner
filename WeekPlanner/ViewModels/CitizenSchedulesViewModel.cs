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

namespace WeekPlanner.ViewModels
{
    public class CitizenSchedulesViewModel : ViewModelBase
    {
        private readonly IRequestService _requestService;
        private readonly IWeekApi _weekApi;
        private readonly ILoginService _loginService;
        private readonly ISettingsService _settingsService;

        public ICommand WeekTappedCommand => new Command((tappedItem) => ListViewItemTapped((WeekDTO)tappedItem));
        public ICommand WeekDeletedCommand => new Command((x) => WeekDeletedTapped(x));
        public ICommand AddWeekScheduleCommand => new Command(() => AddWeekSchedule());

        public CitizenSchedulesViewModel(INavigationService navigationService, IRequestService requestService, IWeekApi weekApi, ILoginService loginService, ISettingsService settingsService) : base(navigationService)
        {
            _requestService = requestService;
            _weekApi = weekApi;
            _loginService = loginService;
            _settingsService = settingsService;
        }

        private ObservableCollection<WeekNameDTO> _namesAndID = new ObservableCollection<WeekNameDTO>();
        public ObservableCollection<WeekNameDTO> NamesAndID
        {
            get => _namesAndID;
            set
            {
                _namesAndID = value;
                RaisePropertyChanged(() => NamesAndID);
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

        private ObservableCollection<PictogramDTO> _weekImage;
        public ObservableCollection<PictogramDTO> WeekImage
        {
            get => _weekImage;
            set
            {
                _weekImage = value;
                RaisePropertyChanged(() => WeekImage);
            }
        }
        private async void ListViewItemTapped(WeekDTO tappedItem)
        {
            await NavigationService.NavigateToAsync<WeekPlannerViewModel>(tappedItem);
        }

        public async Task InitializeWeekSchedules()
        {
            await _requestService.SendRequestAndThenAsync(this,
                requestAsync: async () => await _weekApi.V1WeekGetAsync(),
                onSuccess: result => { NamesAndID = new ObservableCollection<WeekNameDTO>(result.Data); });

            foreach (var item in NamesAndID)
            {
                Weeks.Add(_weekApi.V1WeekByIdGet(item.Id).Data);
            }
        }
        private void WeekDeletedTapped(Object week)
        {
            if (week is WeekDTO weekDTO)
            {

                DeleteWeek(weekDTO);
            }
        }

        private void DeleteWeek(WeekDTO w)
        {

            _requestService.SendRequestAndThenAsync<CitizenSchedulesViewModel, ResponseWeekDTO>(this, async () => { await _weekApi.V1WeekByIdDeleteAsync(w.Id); return null; }, onSuccess: result => { });

        }

        private async void AddWeekSchedule()
        {
            await NavigationService.NavigateToAsync<NewScheduleViewModel>();
        }
        public override async Task InitializeAsync(object navigationData)
        {
            if (navigationData is UserNameDTO userNameDTO)
            {
                await _loginService.LoginAndThenAsync(InitializeWeekSchedules, UserType.Citizen, userNameDTO.UserName);
            }
            else
            {
                throw new ArgumentException("Must be of type userNameDTO", nameof(navigationData));
            }
        }
    }
}
