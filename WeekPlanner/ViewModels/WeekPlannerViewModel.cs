using System;
using System.IO;
using IO.Swagger.Model;
using System.Threading.Tasks;
using IO.Swagger.Api;
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
using WeekPlanner.Services.Request;
using WeekPlanner.Views;
using static IO.Swagger.Model.WeekdayDTO;

namespace WeekPlanner.ViewModels
{
    public class WeekPlannerViewModel : ViewModelBase
    {
        private readonly ILoginService _loginService;
        private readonly IRequestService _requestService;
        private readonly IWeekApi _weekApi;

        private bool _editModeEnabled;
        private WeekDTO _weekDto;
        private DayEnum _weekdayToAddPictogramTo;
        private ImageSource _userModeImage;

        public bool EditModeEnabled
        {
            get => _editModeEnabled;
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

        public ICommand PictoClickedCommand => new Command<StatefulPictogram>(async imageSource =>
            await NavigationService.NavigateToAsync<ActivityViewModel>(imageSource));

        public WeekPlannerViewModel(INavigationService navigationService, ILoginService loginService,
            IRequestService requestService, IWeekApi weekApi) : base(navigationService)
        {
            _loginService = loginService;

            UserModeImage = (FileImageSource) ImageSource.FromFile("icon_default_citizen.png");

            _requestService = requestService;
            _weekApi = weekApi;

            MessagingCenter.Subscribe<WeekPlannerPage>(this, MessageKeys.ScheduleSaveRequest,
                async _ => await SaveSchedule());
            MessagingCenter.Subscribe<PictogramSearchViewModel, PictogramDTO>(this, MessageKeys.PictoSearchChosenItem,
                InsertPicto);
            MessagingCenter.Subscribe<ActivityViewModel, int>(this, MessageKeys.DeleteActivity,
                DeleteActivity);
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

        // TODO: Handle situation where no days exist
        private async Task GetWeekPlanForCitizenAsync()
        {
            // TODO: Make dynamic regarding weekId
            await _requestService.SendRequestAndThenAsync(this,
                requestAsync: async () => await _weekApi.V1WeekByIdGetAsync(1),
                onSuccessAsync: async result =>
                {
                    WeekDTO = result.Data;
                    SetWeekdayPictos();
                },
                onExceptionAsync: async () => await NavigationService.PopAsync(),
                onRequestFailedAsync: async () => await NavigationService.PopAsync()
            );
        }

        private void InsertPicto(PictogramSearchViewModel sender, PictogramDTO pictogramDTO)
        {
            StatefulPictogram statefulPictogram = new StatefulPictogram(GlobalSettings.DefaultEndpoint + pictogramDTO.ImageUrl,
                PictogramState.Normal);
            WeekdayPictos[_weekdayToAddPictogramTo].Add(statefulPictogram);
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
            await _requestService.SendRequestAndThenAsync(this,
                async () => await _weekApi.V1WeekPostAsync(WeekDTO),
                result =>
                {
                    MessagingCenter.Send(this, MessageKeys.RequestSucceeded,
                        $"Ugeplanen '{result.Data.Name}' blev oprettet og gemt.");
                });
        }

        private async Task UpdateExistingSchedule()
        {
            if (WeekDTO.Id == null)
            {
                throw new InvalidDataException("WeekDTO should always have an Id when updating.");
            }

            await _requestService.SendRequestAndThenAsync(this,
                async () => await _weekApi.V1WeekByIdPutAsync((int) WeekDTO.Id, WeekDTO),
                result =>
                {
                    MessagingCenter.Send(this, MessageKeys.RequestSucceeded,
                        $"Ugeplanen '{result.Data.Name}' blev gemt.");
                });
        }


        private void DeleteActivity(ActivityViewModel activityVM, int activityID)
        {
            // TODO: Remove activityID from List<Resource> 
        }

        private void SetWeekdayPictos()
        {
            var tempDict = new Dictionary<DayEnum, ObservableCollection<StatefulPictogram>>();

            foreach (DayEnum day in Enum.GetValues(typeof(DayEnum)))
            {
                tempDict.Add(day, new ObservableCollection<StatefulPictogram>());
            }

            foreach (WeekdayDTO dayDTO in WeekDTO.Days)
            {
                if (dayDTO.Day == null) continue;
                var weekday = dayDTO.Day.Value;
                ObservableCollection<StatefulPictogram> pictos = new ObservableCollection<StatefulPictogram>();
                foreach (var eleID in dayDTO.Elements.Select(e => e.Id.Value))
                {
                    pictos.Add(new StatefulPictogram(
                        GlobalSettings.DefaultEndpoint + $"/v1/pictogram/{eleID}/image/raw", PictogramState.Normal));
                }

                tempDict[weekday] = pictos;
            }

            WeekdayPictos = tempDict;
        }

        private async Task SwitchUserMode()
        {
            if (EditModeEnabled)
            {
                EditModeEnabled = false;
                UserModeImage = (FileImageSource) ImageSource.FromFile("icon_default_citizen.png");
            }
            else
            {
                await NavigationService.NavigateToAsync<LoginViewModel>(this);

                MessagingCenter.Subscribe<LoginViewModel>(this, MessageKeys.LoginSucceeded,
                    (sender) => SetToGuardianMode());
            }
        }

        private void SetToGuardianMode()
        {
            EditModeEnabled = true;
            UserModeImage = (FileImageSource) ImageSource.FromFile("icon_default_guardian.png");
            var tempDict = new Dictionary<DayEnum, ObservableCollection<StatefulPictogram>>();

            foreach (DayEnum day in Enum.GetValues(typeof(DayEnum)))
            {
                tempDict.Add(day, new ObservableCollection<StatefulPictogram>());
            }

            foreach (WeekdayDTO dayDTO in WeekDTO.Days)
            {
                var weekday = dayDTO.Day.Value;
                ObservableCollection<StatefulPictogram> pictos = new ObservableCollection<StatefulPictogram>();
                foreach (var eleID in dayDTO.Elements)
                {
                    pictos.Add(new StatefulPictogram(
                        GlobalSettings.DefaultEndpoint + $"/v1/pictogram/{eleID}/image/raw", PictogramState.Normal));
                }

                tempDict[weekday] = pictos;
            }

            WeekdayPictos = tempDict;
        }


        #region Boilerplate for each weekday's pictos

        private Dictionary<DayEnum, ObservableCollection<StatefulPictogram>> _weekdayPictos =
            new Dictionary<DayEnum, ObservableCollection<StatefulPictogram>>();

        public Dictionary<DayEnum, ObservableCollection<StatefulPictogram>> WeekdayPictos
        {
            get => _weekdayPictos;
            set
            {
                _weekdayPictos = value;
                SetBorderStatusPictograms(DateTime.Today.DayOfWeek);
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

        public ObservableCollection<StatefulPictogram> MondayPictos => GetPictosOrEmptyList(DayEnum.Monday);

        public ObservableCollection<StatefulPictogram> TuesdayPictos => GetPictosOrEmptyList(DayEnum.Tuesday);

        public ObservableCollection<StatefulPictogram> WednesdayPictos => GetPictosOrEmptyList(DayEnum.Wednesday);

        public ObservableCollection<StatefulPictogram> ThursdayPictos => GetPictosOrEmptyList(DayEnum.Thursday);

        public ObservableCollection<StatefulPictogram> FridayPictos => GetPictosOrEmptyList(DayEnum.Friday);

        public ObservableCollection<StatefulPictogram> SaturdayPictos => GetPictosOrEmptyList(DayEnum.Saturday);

        public ObservableCollection<StatefulPictogram> SundayPictos => GetPictosOrEmptyList(DayEnum.Sunday);

        private ObservableCollection<StatefulPictogram> GetPictosOrEmptyList(DayEnum day)
        {
            if (!WeekdayPictos.TryGetValue(day, out var pictoSources))
                pictoSources = new ObservableCollection<StatefulPictogram>();
            return new ObservableCollection<StatefulPictogram>(pictoSources);
        }

        // An enum type for determining which state a pictogram is in.

        public enum PictogramState

        {
            Normal = 0,
            Cancelled = 1,
            Checked = 2
        }


        /// <summary>
        ///  Converts a DayOfWeek to a WeekdayDTO
        /// </summary>
        public class DateTimeConverter
        {
            public DateTimeConverter()
            {
            }

            // Convert a specific day.
            public WeekdayDTO.DayEnum GetWeekDay(DayOfWeek weekDay)
            {
                switch (weekDay)
                {
                    case DayOfWeek.Monday:
                        return WeekdayDTO.DayEnum.Monday;
                    case DayOfWeek.Tuesday:
                        return WeekdayDTO.DayEnum.Tuesday;
                    case DayOfWeek.Wednesday:
                        return WeekdayDTO.DayEnum.Wednesday;
                    case DayOfWeek.Thursday:
                        return WeekdayDTO.DayEnum.Thursday;
                    case DayOfWeek.Friday:
                        return WeekdayDTO.DayEnum.Friday;
                    case DayOfWeek.Saturday:
                        return WeekdayDTO.DayEnum.Saturday;
                    case DayOfWeek.Sunday:
                        return WeekdayDTO.DayEnum.Sunday;
                    default:
                        return WeekdayDTO.DayEnum.Monday;
                }
            }
        }
        
        public void SetBorderStatusPictograms(DayOfWeek weekday)
        {
            // Find the current day in WeekDTO object.
            DateTimeConverter dateTimeConverter = new DateTimeConverter();

            // Find the first pictogram, that are: normal state and first.
            foreach (var weekDayPicto in WeekdayPictos)
            {
                if (weekDayPicto.Key == dateTimeConverter.GetWeekDay(weekday))
                {
                    weekDayPicto.Value.Where((s) => s.PictogramState == PictogramState.Normal).First().Border = "Black";
                    return;
                }
            }
        }
        
        /// <summary>
        ///  A mock class for pictograms, it contains both the URL and State of a pictogram. 
        /// </summary>
        public class StatefulPictogram
        {
            private string _url;

            public string URL
            {
                get { return _url; }
                set { _url = value; }
            }

            private PictogramState _pictogramState;

            public PictogramState PictogramState
            {
                get { return _pictogramState; }
                set { _pictogramState = value; }
            }

            private string _border;

            public string Border
            {
                get { return _border; }
                set { _border = value; }
            }

            public StatefulPictogram(string url, PictogramState pictogramState)
            {
                PictogramState = pictogramState;
                URL = url;
                Border = "Transparent";
            }
        }

        #endregion
    }
}