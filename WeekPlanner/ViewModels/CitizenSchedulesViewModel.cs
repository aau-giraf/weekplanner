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

namespace WeekPlanner.ViewModels
{
    public class CitizenSchedulesViewModel : ViewModelBase
    {
        private readonly IRequestService _requestService;
        private readonly IDialogService _dialogService;
        private readonly IWeekApi _weekApi;
        private readonly ILoginService _loginService;
        private readonly ISettingsService _settingsService;

        public ICommand WeekTappedCommand => new Command((tappedItem) => ListViewItemTapped((WeekDTO)tappedItem));
        public ICommand WeekDeletedCommand => new Command((x) => WeekDeletedTapped(x));
        public ICommand AddWeekScheduleCommand => new Command(() => AddWeekSchedule());

        public CitizenSchedulesViewModel(INavigationService navigationService, IRequestService requestService, IDialogService dialogService, IWeekApi weekApi, ILoginService loginService, ISettingsService settingsService) : base(navigationService)
        {
            _requestService = requestService;
            _dialogService = dialogService;
            _weekApi = weekApi;
            _loginService = loginService;
            _settingsService = settingsService;
            AddIcon = (FileImageSource)ImageSource.FromFile("icon_add.png");
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

        private ImageSource _addIcon;
        public ImageSource AddIcon
        {
            get => _addIcon;
            set
            {
                _addIcon = value;
                RaisePropertyChanged(() => AddIcon);
            }
        }

        private async void ListViewItemTapped(WeekDTO tappedItem)
        {
            await NavigationService.NavigateToAsync<WeekPlannerViewModel>(tappedItem.Id);
        }

        public async Task InitializeWeekSchedules()
        {
            await _requestService.SendRequestAndThenAsync(
                requestAsync: () => _weekApi.V1WeekGetAsync(),
                onSuccess: result => { NamesAndID = new ObservableCollection<WeekNameDTO>(result.Data); });

            foreach (var item in NamesAndID)
            {
                await _requestService.SendRequestAndThenAsync(
                    () => _weekApi.V1WeekByIdGetAsync(item.Id), (res) => Weeks.Add(res.Data));
            }
        }
        private async Task WeekDeletedTapped(Object week)
        {
            if (week is WeekDTO weekDTO)
            { 
                await DeleteWeek(weekDTO);
            }
        }

        private async Task DeleteWeek(WeekDTO week)
        {
            var confirmed = await _dialogService.ConfirmAsync($"Vil du slette {week.Name}?", "Slet Ugeplan");
            if (!confirmed) {
                return;
            }
            await _requestService.SendRequestAndThenAsync(
                requestAsync: () => _weekApi.V1WeekByIdDeleteAsync(week.Id), onSuccess: (r) => Weeks.Remove(week));
        }

        private async Task AddWeekSchedule()
        {
            await NavigationService.NavigateToAsync<NewScheduleViewModel>();
        }

        public override async Task PoppedAsync(object navigationData) {
            Weeks.Clear();
            await InitializeWeekSchedules();
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
