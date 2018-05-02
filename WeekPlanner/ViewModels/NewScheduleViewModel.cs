using IO.Swagger.Api;
using IO.Swagger.Model;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Input;
using WeekPlanner.Helpers;
using WeekPlanner.Services;
using WeekPlanner.Services.Login;
using WeekPlanner.Services.Navigation;
using WeekPlanner.Services.Request;
using WeekPlanner.Validations;
using WeekPlanner.ViewModels.Base;
using Xamarin.Forms;

namespace WeekPlanner.ViewModels
{
    public class NewScheduleViewModel : ViewModelBase
    {
        /// <summary>
        /// Small wrapper for handling which days have been toggled.
        /// Inheritance from Switch means we don't have to manually handle PropertyChanged etc.
        /// </summary>
        public class DayToggledWrapper : Switch
        {
            public readonly WeekdayDTO.DayEnum Day;
            public DayToggledWrapper(WeekdayDTO.DayEnum day)
            {
                IsToggled = true;
                Day = day;
            }
        }

        private ObservableCollection<DayToggledWrapper> _toggledDays;
        public ObservableCollection<DayToggledWrapper> ToggledDays => _toggledDays;

        private WeekDTO _weekDTO = new WeekDTO();

        private readonly IWeekApi _weekApi;
        private readonly IPictogramApi _pictogramApi;
        private readonly IDialogService _dialogService;
        private readonly IRequestService _requestService;

        private ValidatableObject<string> _scheduleName;
        public ValidatableObject<string> ScheduleName
        {
            get => _scheduleName;
            set
            {
                _scheduleName = value;
                RaisePropertyChanged(() => ScheduleName);
            }
        }
        private PictogramDTO _weekThumbNail;
        public PictogramDTO WeekThumbNail
        {
            get => _weekThumbNail;
            set
            {
                _weekThumbNail = value;
                RaisePropertyChanged(() => WeekThumbNail);
            }
        }

        public ICommand SaveWeekScheduleCommand => new Command(SaveWeekSchedule);
        public ICommand ChangePictogramCommand => new Command(ChangePictogram);

        public NewScheduleViewModel(
            INavigationService navigationService, 
            IWeekApi weekApi, 
            IPictogramApi pictogramApi, 
            IRequestService  requestService, 
            IDialogService dialogService) : base(navigationService)
        {
            _weekApi = weekApi;
            _pictogramApi = pictogramApi;
            _requestService = requestService;
            _dialogService = dialogService;

            _weekDTO.Thumbnail = _pictogramApi.V1PictogramByIdGet(2).Data;
            WeekThumbNail = _weekDTO.Thumbnail;

            _scheduleName = new ValidatableObject<string>(new IsNotNullOrEmptyRule<string> { ValidationMessage = "Et navn er påkrævet." });

            _toggledDays = PopulateToggableDaysList();
        }

        private ObservableCollection<DayToggledWrapper> PopulateToggableDaysList()
        {
            var result = new ObservableCollection<DayToggledWrapper>();

            foreach (WeekdayDTO.DayEnum day in Enum.GetValues(typeof(WeekdayDTO.DayEnum)))
            {
                result.Add(new DayToggledWrapper(day));
            }

            return result;
        }

		public override Task PoppedAsync(object navigationData)
		{
            // Happens when selecting a picto in PictoSearch
            if (navigationData is PictogramDTO pictoDTO){
                WeekThumbNail = pictoDTO;
            }
            return Task.FromResult(false);
		}


		private void ChangePictogram()
		{
		    if (IsBusy) return;
		    IsBusy = true;
            NavigationService.NavigateToAsync<PictogramSearchViewModel>();
		    IsBusy = false;
		}

        private async void SaveWeekSchedule()
        {
            if (IsBusy) return;
            IsBusy = true;
            
            if (ValidateWeekScheduleName())
            {
                _weekDTO.Name = ScheduleName.Value;
                WeekThumbNail.AccessLevel = PictogramDTO.AccessLevelEnum.PUBLIC;
                _weekDTO.Thumbnail = WeekThumbNail;
                _weekDTO.Id = default(int);
                var list = new List<WeekdayDTO>();
                foreach(DayToggledWrapper day in ToggledDays)
                {
                    if (!day.IsToggled) continue;

                    WeekdayDTO weekdayDTO = new WeekdayDTO();
                    weekdayDTO.Day = day.Day;
                    weekdayDTO.Activities = new List<ActivityDTO>();
                    list.Add(weekdayDTO);
                }

                _weekDTO.Days = list;

                await _requestService.SendRequestAndThenAsync(
                requestAsync: () => _weekApi.V1WeekPostAsync(_weekDTO),
                onSuccess: async result => { 
                    await _dialogService.ShowAlertAsync($"Ugeplanen '{result.Data.Name}' blev oprettet og gemt."); 
                    await NavigationService.PopAsync();
                });
            }
            IsBusy = false;
        }

        public ICommand ValidateWeekNameCommand => new Command(() => _scheduleName.Validate());

        private bool ValidateWeekScheduleName()
        {
            var isWeekNameValid = _scheduleName.Validate();
            return isWeekNameValid;
        }
    }
}
