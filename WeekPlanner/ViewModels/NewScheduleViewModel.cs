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
        private bool _isTemplate = false;
        private string _viewName;
        private string _newTempOrSchedule;
        private string _namingTempOrSchedule;
        private string _exampleTempOrSchedule;
        private string _pictoForTempOrSchedule;
        private List<Tuple<int, int>> _yearAndWeek;

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

        public bool IsNewSchedule => !_isTemplate;
        
        public bool IsTemplate
        {
            get => _isTemplate;
            set
            {
                _isTemplate = value;
                RaisePropertyChanged(() => IsTemplate);
                RaisePropertyChanged(() => IsNewSchedule);
            }
        }

        public string ViewName
        {
            get => _viewName;
            private set
            {
                _viewName = value;
                RaisePropertyChanged(() => ViewName);
            }
        }
        public string NewTempOrSchedule
        {
            get => _newTempOrSchedule;
            private set
            {
                _newTempOrSchedule = value;
                RaisePropertyChanged(() => NewTempOrSchedule);
            }
        }

        public string ExampleTempOrSchedule
        {
            get => _exampleTempOrSchedule;
            set
            {
                _exampleTempOrSchedule = value;
                RaisePropertyChanged(() => ExampleTempOrSchedule);
            }
        }

        public string PictoForTempOrSchedule
        {
            get => _pictoForTempOrSchedule;
            private set
            {
                _pictoForTempOrSchedule = value;
                RaisePropertyChanged(() => PictoForTempOrSchedule);
            }
        }

        public string NamingTempOrSchedule
        {
            get => _namingTempOrSchedule;
            private set
            {
                _namingTempOrSchedule = value;
                RaisePropertyChanged(() => NamingTempOrSchedule);
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
        public ICommand CreateWeekScheduleCommand => new Command<string>(async type => await CreateWeekSchedule(type));
        public ICommand GetScheduleDatesCommand => new Command(() => GetScheduleDates());
        public ICommand ValidateWeekNameCommand => new Command(() => _scheduleName.Validate());
        public ICommand CreateTemplateCommand => new Command(async () => await CreateTemplate());

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

            ViewName = "Tilføj en ny ugeplan";
            NewTempOrSchedule = "Ny ugeplan";
            NamingTempOrSchedule = "Navngiv din nye ugeplan";
            ExampleTempOrSchedule = "Eksempel: Min nye ugeplan";
            PictoForTempOrSchedule = "Vælg et passende piktogram til din nye ugeplan";

            if (navigationData is string s)
            {
                if (s == "Template")
                {
                    IsTemplate = true;
                    ViewName = "Tilføj en ny skabelon";
                    NewTempOrSchedule = "Ny skabelon";
                    NamingTempOrSchedule = "Navngiv din nye skabelon";
                    ExampleTempOrSchedule = "Eksempel: Min nye skabelon";
                    PictoForTempOrSchedule = "Vælg et passende piktogram til din nye skabelon";
                }
            }
            else if (navigationData is List<Tuple<int, int>> list)
            {
                _yearAndWeek = list;
            }
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

        private async Task CreateWeekSchedule(string type)
        {
            if (IsBusy) return;
            IsBusy = true;

            if (!string.IsNullOrWhiteSpace(type) && ValidateWeekScheduleName() && ValidateScheduleYearAndWeek())
            {
                bool overwriteSchedule = true;
                _weekDTO.Name = ScheduleName.Value;
                WeekThumbNail.AccessLevel = WeekPictogramDTO.AccessLevelEnum.PUBLIC;
                _weekDTO.Thumbnail = WeekThumbNail;

                var list = new List<WeekdayDTO>();

                foreach (DayEnum day in Enum.GetValues(typeof(DayEnum)))
                {
                    WeekdayDTO weekdayDTO = new WeekdayDTO
                    {
                        Day = day,
                        Activities = new List<ActivityDTO>()
                    };
                    list.Add(weekdayDTO);
                }

                _weekDTO.Days = list;

                //If week already exists
                foreach (var item in _yearAndWeek)
                {
                    if (item.Item1 == ScheduleYear && item.Item2 == ScheduleWeek)
                    {
                        overwriteSchedule = await _dialogService.ConfirmAsync("Du er ved at overskrive en allerede gemt ugeplan i samme uge", "Overskriv Uge", "Annuller", "Overskriv");
                    }
                }

                if (overwriteSchedule)
                {
                    if (type.Equals("Blank"))
                        await NavigationService.NavigateToAsync<WeekPlannerViewModel>(parameter: new Tuple<int, int, WeekDTO>(ScheduleYear, ScheduleWeek, _weekDTO));
                    else if (type.Equals("Template")) //IMPLEMENTED!
                        await NavigationService.NavigateToAsync<ChooseTemplateViewModel>(parameter: new Tuple<int, int, WeekDTO>(ScheduleYear, ScheduleWeek, _weekDTO));
                }
                

                //Else do nothing
            }

            IsBusy = false;
        }

        private async Task CreateTemplate()
        {
            WeekThumbNail.AccessLevel = WeekPictogramDTO.AccessLevelEnum.PUBLIC;

            WeekTemplateDTO weekTemplate = new WeekTemplateDTO()
            {
                Name = ScheduleName.Value,
                Thumbnail = WeekThumbNail
            };

            var list = new List<WeekdayDTO>();

            foreach (DayEnum day in Enum.GetValues(typeof(DayEnum)))
            {
                WeekdayDTO weekdayDTO = new WeekdayDTO
                {
                    Day = day,
                    Activities = new List<ActivityDTO>()
                };
                list.Add(weekdayDTO);
            }

            weekTemplate.Days = list;

            await NavigationService.NavigateToAsync<WeekPlannerTemplateViewModel>(weekTemplate);
            
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