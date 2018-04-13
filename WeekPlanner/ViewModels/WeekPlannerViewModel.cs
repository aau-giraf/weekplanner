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
        
        public bool EditModeEnabled
        {
            get
            {
                return _editModeEnabled;
            }
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
                RaisePropertyChanged(() =>  WeekDTO);
            }
        }
        
        public ICommand ToggleEditModeCommand => new Command(() => EditModeEnabled = !EditModeEnabled);
        public ICommand NavigateToPictoSearchCommand => new Command<DayEnum>(async weekday =>
        {
            _weekdayToAddPictogramTo = weekday;
            await NavigationService.NavigateToAsync<PictogramSearchViewModel>();
        });

        public ICommand PictoClickedCommand => new Command<ImageSource>(async imageSource => 
            await NavigationService.NavigateToAsync<ActivityViewModel>());

        public WeekPlannerViewModel(INavigationService navigationService, IWeekApi weekApi,
            ILoginService loginService, IPictogramApi pictogramApi) : base(navigationService)
        {
            _weekApi = weekApi;
            _pictogramApi = pictogramApi;
            _loginService = loginService;
            MessagingCenter.Subscribe<WeekPlannerPage>(this, MessageKeys.ScheduleSaveRequest, 
                async _ => await SaveSchedule());
            MessagingCenter.Subscribe<PictogramSearchViewModel, PictogramDTO>(this, MessageKeys.PictoSearchChosenItem,
                InsertPicto);
        }

        private void InsertPicto(PictogramSearchViewModel sender, PictogramDTO pictogramDTO)
        {
            ImageSource imgSource =
                ImageSource.FromUri(new Uri(GlobalSettings.DefaultEndpoint + pictogramDTO.ImageUrl));
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
                MessagingCenter.Send(this, MessageKeys.RequestSucceeded, $"Ugeplanen '{result.Data.Name}' blev oprettet og gemt.");
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
                try
                {
                    await GetAndSetPictograms();
                }
                catch (ApiException)
                {
                    SendRequestFailedMessage();
                    await NavigationService.PopAsync();
                }
            }
            else
            {
                SendRequestFailedMessage(result.ErrorKey);
                await NavigationService.PopAsync();
            }
        }

        private async Task GetAndSetPictograms()
        {
            var tempDict = new Dictionary<DayEnum, ObservableCollection<ImageSource>>();
            foreach (WeekdayDTO day in WeekDTO.Days)
            {
                var weekday = day.Day.Value;
                ObservableCollection<ImageSource> pictos = new ObservableCollection<ImageSource>();
                foreach (var eleID in day.ElementIDs)
                {
                    ResponsePictogramDTO response = await _pictogramApi.V1PictogramByIdGetAsync(eleID);
                    if (response?.Success == true)
                    {
                        pictos.Add(
                            ImageSource.FromUri(new Uri(GlobalSettings.DefaultEndpoint + response.Data.ImageUrl)));
                    }
                }

                tempDict.Add(weekday, pictos);
            }

            WeekdayPictos = tempDict;
        }
        
         #region Boilerplate for each weekday's pictos

        private Dictionary<DayEnum, ObservableCollection<ImageSource>> _weekdayPictos =
            new Dictionary<DayEnum, ObservableCollection<ImageSource>>();

        public Dictionary<DayEnum, ObservableCollection<ImageSource>> WeekdayPictos
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
            get
            {
                return _weekdayPictos.Any() ? _weekdayPictos.Max(w => GetPictosOrEmptyList(w.Key).Count) : 0;
            }
        }
        
        public ObservableCollection<ImageSource> MondayPictos => GetPictosOrEmptyList(DayEnum.Monday);

        public ObservableCollection<ImageSource> TuesdayPictos => GetPictosOrEmptyList(DayEnum.Tuesday);

        public ObservableCollection<ImageSource> WednesdayPictos => GetPictosOrEmptyList(DayEnum.Wednesday);

        public ObservableCollection<ImageSource> ThursdayPictos => GetPictosOrEmptyList(DayEnum.Thursday);

        public ObservableCollection<ImageSource> FridayPictos => GetPictosOrEmptyList(DayEnum.Friday);

        public ObservableCollection<ImageSource> SaturdayPictos => GetPictosOrEmptyList(DayEnum.Saturday);

        public ObservableCollection<ImageSource> SundayPictos => GetPictosOrEmptyList(DayEnum.Sunday);

        private ObservableCollection<ImageSource> GetPictosOrEmptyList(DayEnum day)
        {
            if (!WeekdayPictos.TryGetValue(day, out var pictoSources))
                pictoSources = new ObservableCollection<ImageSource>();
            return new ObservableCollection<ImageSource>(pictoSources);
        }

        #endregion

        private void SendRequestFailedMessage(ResponseWeekDTO.ErrorKeyEnum? errorKeyEnum = ResponseWeekDTO.ErrorKeyEnum.Error)
        {
            var friendlyErrorMessage = errorKeyEnum.ToFriendlyString();
            MessagingCenter.Send(this, MessageKeys.RequestFailed, friendlyErrorMessage);
        }
        
    }
}
