using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using IO.Swagger.Api;
using IO.Swagger.Model;
using SimpleJson;
using WeekPlanner.Services.Request;
using WeekPlanner.ViewModels.Base;
using Xamarin.Forms;

namespace WeekPlanner.Services.Settings
{
    public class SettingsService : ExtendedBindableObject, ISettingsService
    {
        private readonly IAccountApi  _accountApi;
        private readonly JsonObject _appSettings;
        private readonly IUserApi _userApi;
        private readonly IRequestService _requestService;

        public SettingsService(IAccountApi accountApi, JsonObject appSettings, IUserApi userApi, IRequestService requestService)
        {
            _accountApi = accountApi;
            _appSettings = appSettings;
            _userApi = userApi;
            _requestService = requestService;
        }

        public string BaseEndpoint
        {
            get { return _appSettings["BaseEndpoint"].ToString(); }
            set { }
        }

        private string _authToken;
        public string AuthToken
        {
            get => _authToken;
            set
            {
                _authToken = value;
                _accountApi.Configuration.ApiKey["Authorization"] = $"bearer {value}";
            }
        }

		public bool MasterPageShowable => IsInGuardianMode && CurrentCitizen != null;
        
        public void ClearSettings()
        {
            AuthToken = default(string);
            IsInGuardianMode = default(bool);
            
            // Set back to default theme
            _currentCitizenSettingDTO.Theme = SettingDTO.ThemeEnum.AndroidBlue;
            SetTheme();
            
            _currentCitizen = default(UserNameDTO);
            _currentCitizenSettingDTO = default(SettingDTO);
            DepartmentId = default(long);
        }

        private bool _isInGuardianMode;
        public bool IsInGuardianMode
        {
            get => _isInGuardianMode;
            set
            {
                _isInGuardianMode = value;
                RaisePropertyChanged(() => IsInGuardianMode);
                RaisePropertyChanged(() => MasterPageShowable);
            }
        }

        private SettingDTO _currentCitizenSettingDTO;
        public SettingDTO CurrentCitizenSettingDTO
        {
            get => _currentCitizenSettingDTO;
            set
            {
                _currentCitizenSettingDTO = value;
                SetTheme();
            }
        }

        private UserNameDTO _currentCitizen;
        
        public UserNameDTO CurrentCitizen
        {
            get => _currentCitizen;
            set
            {
                _currentCitizen = value;
                // get and set settings
                _requestService.SendRequestAndThenAsync(
                    requestAsync: async () => await _userApi.V1UserByIdSettingsGetAsync(CurrentCitizen.UserId),
                    onSuccess: result => CurrentCitizenSettingDTO = result.Data
                );
                RaisePropertyChanged(() => MasterPageShowable);
            }
        }

        public long DepartmentId { get; set; }

        public void SetTheme(){
            
            var resources = Application.Current.Resources;
                       
            resources["MondayColor"] = Color.FromHex(CurrentCitizenSettingDTO.WeekDayColors[0].HexColor);
            resources["TuesdayColor"] = Color.FromHex(CurrentCitizenSettingDTO.WeekDayColors[1].HexColor);
            resources["WednesdayColor"] = Color.FromHex(CurrentCitizenSettingDTO.WeekDayColors[2].HexColor);
            resources["ThursdayColor"] = Color.FromHex(CurrentCitizenSettingDTO.WeekDayColors[3].HexColor);
            resources["FridayColor"] = Color.FromHex(CurrentCitizenSettingDTO.WeekDayColors[4].HexColor);
            resources["SaturdayColor"] = Color.FromHex(CurrentCitizenSettingDTO.WeekDayColors[5].HexColor);
            resources["SundayColor"] = Color.FromHex(CurrentCitizenSettingDTO.WeekDayColors[6].HexColor);
            
            switch (CurrentCitizenSettingDTO.Theme)
            {
                case SettingDTO.ThemeEnum.GirafRed:
                    resources.MergedWith = typeof(Themes.RedTheme);
                    break;
                case SettingDTO.ThemeEnum.GirafYellow:
                    resources.MergedWith = typeof(Themes.OrangeTheme);
                    break;
                case SettingDTO.ThemeEnum.AndroidBlue:
                    resources.MergedWith = typeof(Themes.BlueTheme);
                    break;
                case SettingDTO.ThemeEnum.GirafGreen:
                    resources.MergedWith = typeof(Themes.GreenTheme);
                    break;
                default:
                    break;
            }
        }
    }
}
