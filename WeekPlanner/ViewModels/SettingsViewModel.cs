using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using System.Windows.Input;
using IO.Swagger.Api;
using IO.Swagger.Model;
using WeekPlanner.Services;
using WeekPlanner.Services.Login;
using WeekPlanner.Services.Navigation;
using WeekPlanner.Services.Request;
using WeekPlanner.Services.Settings;
using WeekPlanner.ViewModels.Base;
using Xamarin.Forms;

namespace WeekPlanner.ViewModels
{
    public class SettingsViewModel : ViewModelBase
    {
        private readonly ISettingsService _settingsService;
        private readonly IRequestService _requestService;
        private readonly IDialogService _dialogService;
        private readonly IUserApi _userApi;

        private GirafUserDTO _girafCitizen;
        public GirafUserDTO GirafCitizen
        {
            get => _girafCitizen;
            set
            {
                _girafCitizen = value;
                RaisePropertyChanged(() => GirafCitizen);
            }
        }

        private IEnumerable<SettingDTO.ThemeEnum> _themes { get; set; } = new List<SettingDTO.ThemeEnum>(){
            SettingDTO.ThemeEnum.AndroidBlue, SettingDTO.ThemeEnum.GirafGreen, SettingDTO.ThemeEnum.GirafRed, SettingDTO.ThemeEnum.GirafYellow
        };
        public IEnumerable<SettingDTO.ThemeEnum> Themes => _themes;


        private SettingDTO.ThemeEnum _themeSelected { get; set; }
        public SettingDTO.ThemeEnum ThemeSelected
        {
            get { return _themeSelected; }
            set
            {
                var currentTheme = App.Current.Resources;
                _themeSelected = value;
                switch (value)
                {
                    case SettingDTO.ThemeEnum.GirafRed:
                        currentTheme.MergedWith = typeof(Themes.RedTheme);
                        SetThemeInSettingDTOAntUpdate(_themeSelected);
                        break;
                    case SettingDTO.ThemeEnum.GirafYellow:
                        currentTheme.MergedWith = typeof(Themes.OrangeTheme);
                        SetThemeInSettingDTOAntUpdate(_themeSelected);
                        break;
                    case SettingDTO.ThemeEnum.AndroidBlue:
                        currentTheme.MergedWith = typeof(Themes.BlueTheme);
                        SetThemeInSettingDTOAntUpdate(_themeSelected);
                        break;
                    case SettingDTO.ThemeEnum.GirafGreen:
                        currentTheme.MergedWith = typeof(Themes.GreenTheme);
                        SetThemeInSettingDTOAntUpdate(_themeSelected);
                        break;
                    default:
                        break;

                }
                RaisePropertyChanged(() => ThemeSelected);
            }
        }

        private void SetThemeInSettingDTOAntUpdate(SettingDTO.ThemeEnum pickedTheme){
            _settings.Theme = pickedTheme;
            UpdateSettingsAsync();
            Console.WriteLine("**********************FUCK************************");
        }

        private bool _orientationSlider;
        public bool OrientationSwitch
        {
            get => _orientationSlider;
            set
            {
                if (Settings.Orientation == SettingDTO.OrientationEnum.Portrait)
                {
                    _orientationSlider = true;
                }
                else
                {
                    _orientationSlider = false;
                }
                RaisePropertyChanged(() => OrientationSwitch);
                UpdateSettingsAsync();
            }
        }

        public ICommand HandleSwitchChangedCommand => new Command(() =>
        {
            if (Settings.Orientation == SettingDTO.OrientationEnum.Portrait)
            {
                Settings.Orientation = SettingDTO.OrientationEnum.Landscape;
            }
            else
            {
                Settings.Orientation = SettingDTO.OrientationEnum.Portrait;
            }
        });


        private async void UpdateSettingsAsync()
        {
            await _requestService.SendRequestAndThenAsync(
                requestAsync: () => _userApi.V1UserSettingsPatchAsync(_settings),
                onSuccess: dto => { });
        }


        private SettingDTO.OrientationEnum _orientationSetting;
        private SettingDTO _settings;

        public SettingDTO Settings
        {
            get => _settings;
            set
            {
                _settings = value;
                RaisePropertyChanged(() => Settings);
            }
        }



        public SettingsViewModel(ISettingsService settingsService, INavigationService navigationService,
            IDialogService dialogService, IRequestService requestService, IUserApi userApi) : base(navigationService)
        {
            _settingsService = settingsService;
            _requestService = requestService;
            _userApi = userApi;
            _dialogService = dialogService;

        }

        public override async Task InitializeAsync(object navigationData)
        {
            _settingsService.UseTokenFor(UserType.Citizen);
            await InitializeCitizen();
        }

        private async Task InitializeCitizen()
        {
            await _requestService.SendRequestAndThenAsync(
                requestAsync: async () => await _userApi.V1UserGetAsync(),
                onSuccessAsync: async result =>
                {
                    GirafCitizen = result.Data;
                    await InitalizeSettings();
                },
                onExceptionAsync: async () => await NavigationService.PopAsync(),
                onRequestFailedAsync: async () => await NavigationService.PopAsync());
        }

        private async Task InitalizeSettings()
        {
            await _requestService.SendRequestAndThenAsync(
                requestAsync: async () => await _userApi.V1UserSettingsGetAsync(),
                onSuccess: result =>
                {
                    Settings = result.Data;


                },
                onExceptionAsync: async () => await NavigationService.PopAsync(),
                onRequestFailedAsync: async () => await NavigationService.PopAsync());

        }


    }
}
