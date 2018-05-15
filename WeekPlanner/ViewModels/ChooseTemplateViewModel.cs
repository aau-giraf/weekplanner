using IO.Swagger.Api;
using IO.Swagger.Model;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Globalization;
using System.Threading.Tasks;
using System.Windows.Input;
using WeekPlanner.Helpers;
using WeekPlanner.Services;
using WeekPlanner.Services.Login;
using WeekPlanner.Services.Navigation;
using WeekPlanner.Services.Request;
using WeekPlanner.Services.Settings;
using WeekPlanner.Validations;
using WeekPlanner.ViewModels.Base;
using Xamarin.Forms;
using static IO.Swagger.Model.WeekdayDTO;

namespace WeekPlanner.ViewModels
{
    public class ChooseTemplateViewModel : ViewModelBase
    {
        private readonly IRequestService _requestService;
        private readonly IDialogService _dialogService;
        private readonly IWeekApi _weekApi;
        private readonly IWeekTemplateApi _weekTemplateApi;
        private readonly ILoginService _loginService;
        private readonly ISettingsService _settingsService;

        private ObservableCollection<WeekTemplateNameDTO> _weekTemplateNameDTOS = new ObservableCollection<WeekTemplateNameDTO>();
        private ObservableCollection<WeekTemplateDTO> _weekTemplates = new ObservableCollection<WeekTemplateDTO>();
        private ObservableCollection<PictogramDTO> _templateImages;
        private Tuple<int, int, WeekDTO> _yearScheduleweekAndWeek;
        private List<string> _templateNames = new List<string>();


        public ICommand WeekTemplateTappedCommand => new Command<WeekTemplateDTO>(ListViewItemTapped);
        public ICommand WeekDeletedCommand => new Command<WeekTemplateDTO>(async week => await WeekDeletedTapped(week));

        // Create new weekschedule button in toolbar
        public ICommand ToolbarButtonCommand => new Command(async () => await AddWeekTemplate());
        public bool ShowToolbarButton => true;
        public ImageSource ToolbarButtonIcon => (FileImageSource)ImageSource.FromFile("icon_add.png");

        public ChooseTemplateViewModel(INavigationService navigationService, IRequestService requestService,
            IDialogService dialogService, IWeekApi weekApi, ILoginService loginService,
            ISettingsService settingsService, IWeekTemplateApi weekTemplateApi) : base(navigationService)
        {
            _requestService = requestService;
            _dialogService = dialogService;
            _weekApi = weekApi;
            _weekTemplateApi = weekTemplateApi;
            _loginService = loginService;
            _settingsService = settingsService;
        }

        public ObservableCollection<WeekTemplateNameDTO> WeekTemplateNameDTOS
        {
            get => _weekTemplateNameDTOS;
            set
            {
                _weekTemplateNameDTOS = value;
                RaisePropertyChanged(() => WeekTemplateNameDTOS);
            }
        }

        public ObservableCollection<WeekTemplateDTO> WeekTemplates
        {
            get => _weekTemplates;
            set
            {
                _weekTemplates = value;
                RaisePropertyChanged(() => WeekTemplates);
            }
        }
        public ObservableCollection<PictogramDTO> TemplateImages
        {
            get => _templateImages;
            set
            {
                _templateImages = value;
                RaisePropertyChanged(() => TemplateImages);
            }
        }


        private async void ListViewItemTapped(WeekTemplateDTO tappedItem)
        {
            if (IsBusy) return;

            IsBusy = true;
            _yearScheduleweekAndWeek.Item3.Days.Clear();
            foreach (var day in tappedItem.Days)
            {
                _yearScheduleweekAndWeek.Item3.Days.Add(day);
            }

            await NavigationService.NavigateToAsync<WeekPlannerViewModel>(_yearScheduleweekAndWeek);

            IsBusy = false;
        }

        public async Task InitializeWeekSchedules()
        {
            await _requestService.SendRequestAndThenAsync(
                requestAsync: () => _weekTemplateApi.V1WeekTemplateGetAsync(),
                onSuccess: result => { WeekTemplateNameDTOS = new ObservableCollection<WeekTemplateNameDTO>(result.Data); },
                onRequestFailedAsync: () => Task.FromResult("'No week schedules found is not an error'-fix."));

            foreach (var item in WeekTemplateNameDTOS)
            {
                await _requestService.SendRequestAndThenAsync(
                    () => _weekTemplateApi.V1WeekTemplateByIdGetAsync(item.TemplateId), (res) => WeekTemplates.Add(res.Data));

                _templateNames.Add(item.Name);
            }
        }

        private async Task WeekDeletedTapped(WeekTemplateDTO week)
        {
            if (IsBusy) return;
            IsBusy = true;

            if (week is WeekTemplateDTO weekDTO)
            {
                await DeleteWeek(weekDTO);
            }

            IsBusy = false;
        }

        private async Task DeleteWeek(WeekTemplateDTO week)
        {
            var confirmed = await _dialogService.ConfirmAsync($"Vil du slette {week.Name}?", "Slet Ugeplan");
            if (!confirmed)
            {
                return;
            }

            await _requestService.SendRequestAndThenAsync(
                requestAsync: () => _weekTemplateApi.V1WeekTemplateByIdDeleteAsync(week.Id), 
                onSuccess: (r) => WeekTemplates.Remove(week));

        }

        private async Task AddWeekTemplate()
        {
            if (IsBusy) return;

            IsBusy = true;
            await NavigationService.NavigateToAsync<NewScheduleViewModel>(_templateNames);
            IsBusy = false;
        }

        public override async Task OnReturnedToAsync(object navigationData)
        {
            WeekTemplates.Clear();
            WeekTemplateNameDTOS.Clear();
            await InitializeWeekSchedules();
        }

        public override async Task InitializeAsync(object navigationData)
        {
            switch (navigationData)
            {
                case Tuple<int, int, WeekDTO> yearScheduleweekAndWeek:
                    _yearScheduleweekAndWeek = yearScheduleweekAndWeek;
                    break;
                default:
                    break;
            }
            await NavigationService.RemoveLastFromBackStackAsync();
            await InitializeWeekSchedules();
        }
    }
}

