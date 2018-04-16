using System;
using System.IO;
using IO.Swagger.Model;
using System.Threading.Tasks;
using IO.Swagger.Api;
using IO.Swagger.Client;
using WeekPlanner.Helpers;
using WeekPlanner.Services.Login;
using WeekPlanner.ViewModels.Base;
using Xamarin.Forms;
using WeekPlanner.Services.Navigation;
using System.Collections.ObjectModel;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using WeekPlanner.Services.Settings;
using System.Windows.Input;
using WeekPlanner.Views;
using static IO.Swagger.Model.WeekdayDTO;

namespace WeekPlanner.ViewModels
{
    public class WeekPlannerViewModel : ViewModelBase
    {
        private readonly IWeekApi _weekApi;
        private readonly IPictogramApi _pictogramApi;
        private readonly ILoginService _loginService;

        private bool _editModeEnabled;
        private WeekDTO _weekDto;
        private DayEnum _weekdayToAddPictogramTo;
        private ImageSource _userModeImage;
        
        public bool EditModeEnabled
        {
            get { return _editModeEnabled; }
            set
            {
                _editModeEnabled = value;
                RaisePropertyChanged(() => EditModeEnabled);
            }
        }

        public WeekDTO WeekDTO
        {
            get => _weekDto;
            set
            {
                _weekDto = value;
                RaisePropertyChanged(() => WeekDTO);
            }
        }

        public ImageSource UserModeImage
        {
            get => _userModeImage;
            set
            {
                _userModeImage = value;
                RaisePropertyChanged(() => UserModeImage);
            }
        }

        public ICommand ToggleEditModeCommand => new Command(() => SwitchUserMode());

        public ICommand NavigateToPictoSearchCommand => new Command<DayEnum>(async weekday =>
        {
            _weekdayToAddPictogramTo = weekday;
            await NavigationService.NavigateToAsync<PictogramSearchViewModel>();
        });

        public WeekPlannerViewModel(INavigationService navigationService, IWeekApi weekApi,
            ILoginService loginService, IPictogramApi pictogramApi) : base(navigationService)
        {
            _weekApi = weekApi;
            _pictogramApi = pictogramApi;
            _loginService = loginService;

            UserModeImage = (FileImageSource)ImageSource.FromFile("icon_default_citizen.png");

            MessagingCenter.Subscribe<WeekPlannerPage>(this, MessageKeys.ScheduleSaveRequest,
                async _ => await SaveSchedule());
            MessagingCenter.Subscribe<PictogramSearchViewModel, PictogramDTO>(this, MessageKeys.PictoSearchChosenItem,
                InsertPicto);
        }

        private void InsertPicto(PictogramSearchViewModel sender, PictogramDTO pictogramDTO)
        {
            String imgSource = 
                GlobalSettings.DefaultEndpoint + pictogramDTO.ImageUrl;
            WeekdayPictos[_weekdayToAddPictogramTo].Add(imgSource);
            // Add pictogramId to the correct weekday
            // TODO: Fix
            RaisePropertyChanged(() => MondayPictos);
            RaisePropertyChanged(() => TuesdayPictos);
            RaisePropertyChanged(() => WednesdayPictos);
            RaisePropertyChanged(() => ThursdayPictos);
            RaisePropertyChanged(() => FridayPictos);
            RaisePropertyChanged(() => SaturdayPictos);
            RaisePropertyChanged(() => SundayPictos);
            RaisePropertyChanged(() => CountOfMaxHeightWeekday);
            RaisePropertyChanged(() => WeekdayPictos);
        }


        private async Task SaveSchedule()
        {
            if (WeekDTO.Id is null)
            {
                await SaveNewSchedule();
            }
            else
            {
                await UpdateExistingSchedule();
            }
        }

        private async Task SaveNewSchedule()
        {
            ResponseWeekDTO result;

            try
            {
                // Saves new schedule
                result = await _weekApi.V1WeekPostAsync(WeekDTO);
            }
            catch (ApiException)
            {
                SendRequestFailedMessage();
                return;
            }

            if (result.Success == true)
            {
                MessagingCenter.Send(this, MessageKeys.RequestSucceeded,
                    $"Ugeplanen '{result.Data.Name}' blev oprettet og gemt.");
            }
            else
            {
                SendRequestFailedMessage(result.ErrorKey);
            }
        }

        private async Task UpdateExistingSchedule()
        {
            if (WeekDTO.Id == null)
            {
                throw new InvalidDataException("WeekDTO should always have an Id when updating.");
            }

            ResponseWeekDTO result;
            try
            {
                // TODO remove cast to int when backend has been fixed
                result = await _weekApi.V1WeekByIdPutAsync((int) WeekDTO.Id, WeekDTO);
            }
            catch (ApiException)
            {
                SendRequestFailedMessage();
                return;
            }

            if (result.Success == true)
            {
                MessagingCenter.Send(this, MessageKeys.RequestSucceeded, $"Ugeplanen '{result.Data.Name}' blev gemt.");
            }
            else
            {
                SendRequestFailedMessage(result.ErrorKey);
            }
        }

        public override async Task InitializeAsync(object navigationData)
        {
            if (navigationData is UserNameDTO userNameDTO)
            {
                await _loginService.LoginAndThenAsync(GetWeekPlanForCitizenAsync, UserType.Citizen,
                   userNameDTO.UserName);
            }
            else
            {
                throw new ArgumentException("Must be of type userNameDTO", nameof(navigationData));
            }
        }

        // TODO: Cleanup method and rename
        private async Task GetWeekPlanForCitizenAsync()
        {
            ResponseWeekDTO result;
            try
            {
                // TODO: Find the correct id to retrieve : Modal view -> choose what schedule (probably current by default)
                result = await _weekApi.V1WeekByIdGetAsync(1);
            }
            catch (ApiException)
            {
                SendRequestFailedMessage();
                await NavigationService.PopAsync();
                return;
            }

            if (result.Success == true && result.Data.Days != null)
            {
                WeekDTO = result.Data;
                SetWeekdayPictos();
            }
            else
            {
                SendRequestFailedMessage(result.ErrorKey);
                await NavigationService.PopAsync();
            }
        }

        private void SetWeekdayPictos()
        {
            var tempDict = new Dictionary<DayEnum, ObservableCollection<String>>();
            foreach (WeekdayDTO day in WeekDTO.Days)
            {
                var weekday = day.Day.Value;
                ObservableCollection<String> pictos = new ObservableCollection<String>();
                foreach (var eleID in day.ElementIDs)
                {
                    pictos.Add(
                        GlobalSettings.DefaultEndpoint + $"/v1/pictogram/{eleID}/image/raw");
                }

                tempDict.Add(weekday, pictos);
            }

            WeekdayPictos = tempDict;
        }

        #region Boilerplate for each weekday's pictos

        private Dictionary<DayEnum, ObservableCollection<String>> _weekdayPictos =
            new Dictionary<DayEnum, ObservableCollection<String>>();

        public Dictionary<DayEnum, ObservableCollection<String>> WeekdayPictos
        {
            get => _weekdayPictos;
            set
            {
                _weekdayPictos = value;
                RaisePropertyChanged(() => MondayPictos);
                RaisePropertyChanged(() => TuesdayPictos);
                RaisePropertyChanged(() => WednesdayPictos);
                RaisePropertyChanged(() => ThursdayPictos);
                RaisePropertyChanged(() => FridayPictos);
                RaisePropertyChanged(() => SaturdayPictos);
                RaisePropertyChanged(() => SundayPictos);
                RaisePropertyChanged(() => CountOfMaxHeightWeekday);
                RaisePropertyChanged(() => WeekdayPictos);
            }
        }

        public int CountOfMaxHeightWeekday
        {
            get { return _weekdayPictos.Any() ? _weekdayPictos.Max(w => GetPictosOrEmptyList(w.Key).Count) : 0; }
        }

        public ObservableCollection<String> MondayPictos => GetPictosOrEmptyList(DayEnum.Monday);

        public ObservableCollection<String> TuesdayPictos => GetPictosOrEmptyList(DayEnum.Tuesday);

        public ObservableCollection<String> WednesdayPictos => GetPictosOrEmptyList(DayEnum.Wednesday);

        public ObservableCollection<String> ThursdayPictos => GetPictosOrEmptyList(DayEnum.Thursday);

        public ObservableCollection<String> FridayPictos => GetPictosOrEmptyList(DayEnum.Friday);

        public ObservableCollection<String> SaturdayPictos => GetPictosOrEmptyList(DayEnum.Saturday);

        public ObservableCollection<String> SundayPictos => GetPictosOrEmptyList(DayEnum.Sunday);

        private ObservableCollection<String> GetPictosOrEmptyList(DayEnum day)
        {
            if (!WeekdayPictos.TryGetValue(day, out var pictoSources))
                pictoSources = new ObservableCollection<String>();
            return new ObservableCollection<String>(pictoSources);
        }

        #endregion

        private void SendRequestFailedMessage(
            ResponseWeekDTO.ErrorKeyEnum? errorKeyEnum = ResponseWeekDTO.ErrorKeyEnum.Error)
        {
            var friendlyErrorMessage = errorKeyEnum.ToFriendlyString();
            MessagingCenter.Send(this, MessageKeys.RequestFailed, friendlyErrorMessage);
        }

        private async Task SwitchUserMode()
        {
            if (EditModeEnabled)
            {
                EditModeEnabled = false;
                UserModeImage = (FileImageSource)ImageSource.FromFile("icon_default_citizen.png");
            }
            else
            {
                await NavigationService.NavigateToAsync<LoginViewModel>(this);

                MessagingCenter.Subscribe<LoginViewModel>(this, MessageKeys.LoginSucceeded, (sender) => SetToGuardianMode());
            }
        }

        private void SetToGuardianMode()
        {
            EditModeEnabled = true;
            UserModeImage = (FileImageSource)ImageSource.FromFile("icon_default_guardian.png");
        }
    }
}