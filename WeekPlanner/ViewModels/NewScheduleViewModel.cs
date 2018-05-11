using IO.Swagger.Api;
using IO.Swagger.Model;
using System;
using System.Globalization;
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
using static IO.Swagger.Model.WeekdayDTO;

namespace WeekPlanner.ViewModels
{
    public class NewScheduleViewModel : ViewModelBase
    {
        private readonly IWeekApi _weekApi;
        private readonly IPictogramApi _pictogramApi;
        private readonly IDialogService _dialogService;
        private readonly IRequestService _requestService;

        private WeekPictogramDTO _weekThumbNail;
        private WeekDTO _weekDTO;
        private ValidatableObject<string> _scheduleName;
        private int _scheduleYear;
        private int _scheduleWeek;
        private string _scheduleFromAndToDates;
        private string _scheduleValidateYearAndWeek;

        public ValidatableObject<string> ScheduleName
        {
            get => _scheduleName;
            set
            {
                _scheduleName = value;
                RaisePropertyChanged(() => ScheduleName);
            }
        }

        public WeekPictogramDTO WeekThumbNail
        {
            get => _weekThumbNail;
            set
            {
                _weekThumbNail = value;
                RaisePropertyChanged(() => WeekThumbNail);
            }
        }

        public int ScheduleYear
        {
            get => _scheduleYear;
            set
            {
                _scheduleYear = value;
                RaisePropertyChanged(() => ScheduleYear);
            }
        }

        public int ScheduleWeek
        {
            get => _scheduleWeek;
            set
            {
                _scheduleWeek = value;
                RaisePropertyChanged(() => ScheduleWeek);
            }
        }

        public string ScheduleFromAndToDates
        {
            get => _scheduleFromAndToDates;
            set
            {
                _scheduleFromAndToDates = value;
                RaisePropertyChanged(() => ScheduleFromAndToDates);
            }
        }

        public string ScheduleValidateYearAndWeek
        {
            get => _scheduleValidateYearAndWeek;
            set
            {
                _scheduleValidateYearAndWeek = value;
                RaisePropertyChanged(() => ScheduleValidateYearAndWeek);
            }
        }

        public ICommand ChangePictogramCommand => new Command(ChangePictogram);
        public ICommand CreateWeekScheduleCommand => new Command<string>(async type => CreateWeekSchedule(type));
        public ICommand GetScheduleDatesCommand => new Command(() => GetScheduleDates());
        public ICommand ValidateWeekNameCommand => new Command(() => _scheduleName.Validate());

        public NewScheduleViewModel(
            INavigationService navigationService,
            IWeekApi weekApi,
            IPictogramApi pictogramApi,
            IRequestService requestService,
            IDialogService dialogService) : base(navigationService)
        {
            _weekApi = weekApi;
            _pictogramApi = pictogramApi;
            _requestService = requestService;
            _dialogService = dialogService;

            _weekDTO = new WeekDTO();

            _scheduleName =
                new ValidatableObject<string>(
                    new IsNotNullOrEmptyRule<string> {ValidationMessage = "Et navn er påkrævet."});

            SetYearAndWeek();
        }

        public async override Task InitializeAsync(object navigationData)
        {
            await _requestService.SendRequestAndThenAsync(
                requestAsync: async () => await _pictogramApi.V1PictogramByIdGetAsync(2),
                onSuccess: result =>
                {
                    WeekThumbNail = result.Data;
                },
                onExceptionAsync: () => NavigationService.PopAsync(),
                onRequestFailedAsync: () => NavigationService.PopAsync());

            WeekThumbNail = _pictogramApi.V1PictogramByIdGet(2).Data;
        }

        public override Task PoppedAsync(object navigationData)
        {
            // Happens when selecting a picto in PictoSearch
            if (navigationData is WeekPictogramDTO pictoDTO)
            {
                WeekThumbNail = pictoDTO;
            }

            return Task.FromResult(false);
        }

        private void SetYearAndWeek()
        {
            var nextWeek = DateTime.Now.AddDays(7);
            ScheduleWeek = YearAndWeekHelper.GetIso8601WeekOfYear(nextWeek);
            ScheduleYear = YearAndWeekHelper.GetDaysOfWeekByWeekNumber(nextWeek, ScheduleWeek)[0].Year;

            GetScheduleDates();
        }

        private void ChangePictogram()
        {
            if (IsBusy) return;
            IsBusy = true;
            NavigationService.NavigateToAsync<PictogramSearchViewModel>();
            IsBusy = false;
        }

        private async void CreateWeekSchedule(string type)
        {
            if (IsBusy) return;
            IsBusy = true;

            if (!string.IsNullOrWhiteSpace(type) && ValidateWeekScheduleName() && ValidateScheduleYearAndWeek())
            {
                _weekDTO.Name = ScheduleName.Value;
                WeekThumbNail.AccessLevel = WeekPictogramDTO.AccessLevelEnum.PUBLIC;
                _weekDTO.Thumbnail = WeekThumbNail;

                var list = new List<WeekdayDTO>();

                foreach (DayEnum day in Enum.GetValues(typeof(DayEnum)))
                {
                    WeekdayDTO weekdayDTO = new WeekdayDTO();
                    weekdayDTO.Day = day;
                    weekdayDTO.Activities = new List<ActivityDTO>();
                    list.Add(weekdayDTO);
                }

                _weekDTO.Days = list;

                if (type.Equals("Blank"))
                    await NavigationService.NavigateToAsync<WeekPlannerViewModel>(parameter: new Tuple<int, int, WeekDTO>(ScheduleYear, ScheduleWeek, _weekDTO));
                else if (type.Equals("Template")) //NOT IMPLEMENTED!
                    await NavigationService.NavigateToAsync<ChooseTemplateViewModel>(parameter: new Tuple<int, int, WeekDTO>(ScheduleYear, ScheduleWeek, _weekDTO));

                //Else do nothing
            }

            IsBusy = false;
        }

        private void GetScheduleDates()
        {
            if (!ValidateScheduleYearAndWeek())
            {
                ScheduleFromAndToDates = ""; //Reset the from and to date label
                return;
            }

            var dates = YearAndWeekHelper.GetDaysOfWeekByWeekNumber(new DateTime(ScheduleYear, 1, 1), ScheduleWeek);

            string format = dates[0].Year == dates[6].Year ? "d. MMMM" : "d. MMMM, yyyy"; //Add years to the from and to date label, if the week intersects with two years

            ScheduleFromAndToDates = $"{dates[0].ToString(format, CultureInfo.CreateSpecificCulture("da-DK"))} til {dates[6].ToString(format, CultureInfo.CreateSpecificCulture("da-DK"))}";
        }

        private bool ValidateWeekScheduleName()
        {
            var isWeekNameValid = _scheduleName.Validate();
            return isWeekNameValid;
        }

        private bool ValidateScheduleYearAndWeek()
        {
            bool isValid = true;
            string invalidMessage = "";

            //Illegal arguments
            if (ScheduleWeek > 53 || ScheduleWeek < 1)
            {
                invalidMessage += "Ugenummer skal være mellem 1 og 53. ";
                isValid = false;
            }

            //Invalid arguments
            if (ScheduleYear < DateTime.Now.Year || //A schedule for a past year
                YearAndWeekHelper.GetDaysOfWeekByWeekNumber( // A schedule for past weeks (i.e for weeks in which the last day of the week has passed)
                    new DateTime(ScheduleYear, 1, 1),
                    ScheduleWeek)[6] < DateTime.Today ||
                ScheduleWeek != YearAndWeekHelper.GetIso8601WeekOfYear( //Check if the week is valid (i.e. not week 53 for years with only 52 weeks)
                    YearAndWeekHelper.GetDaysOfWeekByWeekNumber(
                        new DateTime(ScheduleYear, 1, 1),
                        ScheduleWeek)[0]))
            {
                invalidMessage += "Den valgte dato er ikke valid. Enten er der valgt en passeret dato, eller også er der valgt et ikke-gyldigt ugenummer.";
                isValid = false;
            }

            ScheduleValidateYearAndWeek = invalidMessage;

            return isValid;
        }
    }
}