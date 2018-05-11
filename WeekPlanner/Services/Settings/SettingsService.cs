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
        
        private static string _token;
        public static Task<string> GetToken()
        {
            return Task.FromResult(_token);
        }

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

        public bool UseMocks { get; set; }

        public DepartmentNameDTO Department { get; set; }

        public string AuthToken
        {
            get => _authToken;
            set
            {
                _authToken = value;
                _accountApi.Configuration.ApiKey["Authorization"] = $"bearer {value}";
            }
        }


        private bool _isInGuardianMode;

        public bool IsInGuardianMode
        {
            get => _isInGuardianMode;
            set
            {
                _isInGuardianMode = value;
                RaisePropertyChanged(() => IsInGuardianMode);
            }
        }

        private string _currentCitizenId;
        public string CurrentCitizenId
        {
            get => _currentCitizenId;
            set
            {
                _currentCitizenId = value;
                RaisePropertyChanged(() => CurrentCitizenId);
            } 
        }
        private string _currentCitizenName;
        private string _authToken;

        public string CurrentCitizenName
        {
            get => _currentCitizenName;
            set
            {
                _currentCitizenName = value;
                RaisePropertyChanged(() => CurrentCitizenName);
            }
        }

        public SettingDTO CurrentCitizenSettingDTO { get; set; }
        
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
