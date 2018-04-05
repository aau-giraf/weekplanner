using System;
using System.Collections.Concurrent;
using System.IO;
using System.Net;
using System.Text;
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
using System.Collections.Specialized;
using System.Linq;
using WeekPlanner.Services.Settings;
using System.Reflection;
using System.Runtime.CompilerServices;
using System.Windows.Input;
using CarouselView.FormsPlugin.Abstractions;
using FFImageLoading.Forms.Args;
using NUnit.Framework;
using WeekPlanner.Views;

namespace WeekPlanner.ViewModels
{
    public class WeekPlannerViewModel : ViewModelBase
    {

        private readonly IWeekApi _weekApi;
        private readonly IPictogramApi _pictogramApi;
        private readonly ILoginService _loginService;
        
        private bool _editModeEnabled;
        private WeekDTO _weekDto;
        
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
        public ICommand NavigateToPictoSearchCommand => new Command(async () =>
        {
            await NavigationService.NavigateToAsync<PictogramSearchViewModel>();
        });

        public WeekPlannerViewModel(INavigationService navigationService, IWeekApi weekApi,
            ILoginService loginService, IPictogramApi pictogramApi) : base(navigationService)
        {
            _weekApi = weekApi;
            _pictogramApi = pictogramApi;
            _loginService = loginService;
            MessagingCenter.Subscribe<WeekPlannerPage>(this, MessageKeys.ScheduleSaveRequest, 
                async _ => await SaveSchedule());
            //MessagingCenter.Subscribe(subscriber:this, message:MessageKeys.PictoSearchChosenItem, callback:InsertPicto, source:null);
        }

        private void InsertPicto(object arg1, object arg2)
        {
            throw new NotImplementedException();
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
            var tempDict = new Dictionary<WeekdayDTO.DayEnum, IEnumerable<ImageSource>>();
            foreach (WeekdayDTO day in WeekDTO.Days)
            {
                var weekday = day.Day.Value;
                List<ImageSource> pictos = new List<ImageSource>();
                foreach (var ele in day.Elements)
                {
                    ResponsePictogramDTO response = await _pictogramApi.V1PictogramByIdGetAsync(ele.Id);
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

        private IReadOnlyDictionary<WeekdayDTO.DayEnum, IEnumerable<ImageSource>> _weekdayPictos =
            new Dictionary<WeekdayDTO.DayEnum, IEnumerable<ImageSource>>();

        public IReadOnlyDictionary<WeekdayDTO.DayEnum, IEnumerable<ImageSource>> WeekdayPictos
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
            }
        }
        
        public int CountOfMaxHeightWeekday
        {
            get
            {
                return _weekdayPictos.Any() ? _weekdayPictos.Max(w => GetPictosOrEmptyList(w.Key).Count) : 0;
            }
        }
        
        public ObservableCollection<ImageSource> MondayPictos => GetPictosOrEmptyList(WeekdayDTO.DayEnum.Monday);

        public ObservableCollection<ImageSource> TuesdayPictos => GetPictosOrEmptyList(WeekdayDTO.DayEnum.Tuesday);

        public ObservableCollection<ImageSource> WednesdayPictos => GetPictosOrEmptyList(WeekdayDTO.DayEnum.Wednesday);

        public ObservableCollection<ImageSource> ThursdayPictos => GetPictosOrEmptyList(WeekdayDTO.DayEnum.Thursday);

        public ObservableCollection<ImageSource> FridayPictos => GetPictosOrEmptyList(WeekdayDTO.DayEnum.Friday);

        public ObservableCollection<ImageSource> SaturdayPictos => GetPictosOrEmptyList(WeekdayDTO.DayEnum.Saturday);

        public ObservableCollection<ImageSource> SundayPictos => GetPictosOrEmptyList(WeekdayDTO.DayEnum.Sunday);

        private ObservableCollection<ImageSource> GetPictosOrEmptyList(WeekdayDTO.DayEnum day)
        {
            IEnumerable<ImageSource> pictoSources;
            if (!WeekdayPictos.TryGetValue(day, out pictoSources))
                pictoSources = new List<ImageSource>();
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