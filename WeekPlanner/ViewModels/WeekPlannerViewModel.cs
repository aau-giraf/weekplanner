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
using WeekPlanner.Services;

namespace WeekPlanner.ViewModels
{
    public class WeekPlannerViewModel : ViewModelBase
    {
        private readonly ILoginService _loginService;
        private readonly IRequestService _requestService;
        private readonly IWeekApi _weekApi;
        private readonly IDialogService _dialogService;
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

        public ICommand SaveCommand => new Command(async () => await SaveSchedule());

        public ICommand NavigateToPictoSearchCommand => new Command<DayEnum>(async weekday =>
        {
            _weekdayToAddPictogramTo = weekday;
            await NavigationService.NavigateToAsync<PictogramSearchViewModel>();
        });

        public ICommand PictoClickedCommand => new Command<string>(async imageSource => 
            await NavigationService.NavigateToAsync<ActivityViewModel>(imageSource));

        public WeekPlannerViewModel(INavigationService navigationService, ILoginService loginService, 
            IRequestService requestService, IWeekApi weekApi, IDialogService dialogService) : base(navigationService)
        {
            _requestService = requestService;
            _weekApi = weekApi;
            _dialogService = dialogService;
            _loginService = loginService;

            UserModeImage = (FileImageSource)ImageSource.FromFile("icon_default_citizen.png");
            
            MessagingCenter.Subscribe<PictogramSearchViewModel, PictogramDTO>(this, MessageKeys.PictoSearchChosenItem,
                InsertPicto);
            MessagingCenter.Subscribe<ActivityViewModel, int>(this, MessageKeys.DeleteActivity,
                DeleteActivity);
            MessagingCenter.Subscribe<LoginViewModel>(this, MessageKeys.LoginSucceeded, (sender) => SetToGuardianMode());
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
            string imgSource = 
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
            bool confirmed = await _dialogService.ConfirmAsync(
                title: "Gem ugeplan", 
                message: "Vil du gemme ugeplanen?", 
                okText: "Gem", 
                cancelText: "Annuller");

			if(!confirmed){
                return;   
            }
            
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
                async () => await _weekApi.V1WeekPostAsync(WeekDTO), result => 
                {
                    _dialogService.ShowAlertAsync(message: $"Ugeplanen '{result.Data.Name}' blev oprettet og gemt.");
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
                    _dialogService.ShowAlertAsync(message: $"Ugeplanen '{result.Data.Name}' blev gemt.");
                });
        }


        private void DeleteActivity(ActivityViewModel activityVM, int activityID) {
            // TODO: Remove activityID from List<Resource> 
        }

        private void SetWeekdayPictos()
        {
            var tempDict = new Dictionary<DayEnum, ObservableCollection<string>>();
            
            foreach (DayEnum day in Enum.GetValues(typeof(DayEnum)))
            {
                tempDict.Add(day, new ObservableCollection<string>());
            }
            
            foreach (WeekdayDTO dayDTO in WeekDTO.Days)
            {
                if (dayDTO.Day == null) continue;
                var weekday = dayDTO.Day.Value;
                ObservableCollection<string> pictos = new ObservableCollection<string>();
                foreach (var eleID in dayDTO.Elements.Select(e => e.Id.Value))
                {
                    pictos.Add(
                        GlobalSettings.DefaultEndpoint + $"/v1/pictogram/{eleID}/image/raw");
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
                UserModeImage = (FileImageSource)ImageSource.FromFile("icon_default_citizen.png");
            }
            else
            {
                await NavigationService.NavigateToAsync<LoginViewModel>(this);
            }
        }

        private void SetToGuardianMode()
        {
            EditModeEnabled = true;
            UserModeImage = (FileImageSource)ImageSource.FromFile("icon_default_guardian.png");
            var tempDict = new Dictionary<DayEnum, ObservableCollection<string>>();
            
            foreach (DayEnum day in Enum.GetValues(typeof(DayEnum)))
            {
                tempDict.Add(day, new ObservableCollection<string>());
            }
            
            foreach (WeekdayDTO dayDTO in WeekDTO.Days)
            {
                var weekday = dayDTO.Day.Value;
                ObservableCollection<string> pictos = new ObservableCollection<string>();
                foreach (var eleID in dayDTO.Elements)
                {
                    pictos.Add(
                        GlobalSettings.DefaultEndpoint + $"/v1/pictogram/{eleID}/image/raw");
                }
                tempDict[weekday] = pictos;
            }

            WeekdayPictos = tempDict;
        }


        #region Boilerplate for each weekday's pictos

        private Dictionary<DayEnum, ObservableCollection<string>> _weekdayPictos =
            new Dictionary<DayEnum, ObservableCollection<string>>();

        public Dictionary<DayEnum, ObservableCollection<string>> WeekdayPictos
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

        public ObservableCollection<string> MondayPictos => GetPictosOrEmptyList(DayEnum.Monday);

        public ObservableCollection<string> TuesdayPictos => GetPictosOrEmptyList(DayEnum.Tuesday);

        public ObservableCollection<string> WednesdayPictos => GetPictosOrEmptyList(DayEnum.Wednesday);

        public ObservableCollection<string> ThursdayPictos => GetPictosOrEmptyList(DayEnum.Thursday);

        public ObservableCollection<string> FridayPictos => GetPictosOrEmptyList(DayEnum.Friday);

        public ObservableCollection<string> SaturdayPictos => GetPictosOrEmptyList(DayEnum.Saturday);

        public ObservableCollection<string> SundayPictos => GetPictosOrEmptyList(DayEnum.Sunday);

        private ObservableCollection<string> GetPictosOrEmptyList(DayEnum day)
        {
            if (!WeekdayPictos.TryGetValue(day, out var pictoSources))
                pictoSources = new ObservableCollection<string>();
            return new ObservableCollection<string>(pictoSources);
        }

        #endregion
       
    }
}