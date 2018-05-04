using System;
using System.Threading.Tasks;
using IO.Swagger.Api;
using IO.Swagger.Model;
using SimpleJson;
using WeekPlanner.Services.Request;
using Xamarin.Forms;

namespace WeekPlanner.Services.Settings
{
    public class SettingsService : ISettingsService
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

        public string GuardianAuthToken { get; set; }

        public string CitizenAuthToken { get; set; }
        
        public string CurrentCitizenId { get; set; }    

        public SettingDTO CurrentCitizenSettingDTO { get; set; }


        /// <summary>
        /// Sets the API up to using the specified type of authentication token.
        /// </summary>
        /// <param name="userType">The UserType to use a token for.</param>
        /// <exception cref="ArgumentOutOfRangeException">When given an unknown UserType</exception>
        /// <exception cref="ArgumentException">If the token for the specified UserType is not already set.</exception>
        public void UseTokenFor(UserType userType)
        {
            switch(userType)
            {
                case UserType.Citizen:
                    SetAuthTokenInAccountApi(CitizenAuthToken);
                    _token = CitizenAuthToken;
                    break;
                case UserType.Guardian:
                    SetAuthTokenInAccountApi(GuardianAuthToken);
                    _token = GuardianAuthToken;
                    break;
                default:
                    throw new ArgumentOutOfRangeException(nameof(userType), userType, null);
            }
        }
        

        private void SetAuthTokenInAccountApi(string authToken)
        {
            if (string.IsNullOrEmpty(authToken))
            {
                throw new ArgumentException("Can not be null or empty.", nameof(authToken));
            }
            
            // The 'bearer' part is necessary, because it uses the Bearer Authentication
            _accountApi.Configuration.AddApiKey("Authorization", $"bearer {authToken}");
        }

        public void SetThemeOnLogin(){
            var resources = Xamarin.Forms.Application.Current.Resources;
            App.Current.Resources["MondayColor"] = Color.FromHex(CurrentCitizenSettingDTO.WeekDayColors[0].HexColor);
            App.Current.Resources["TuesdayColor"] = Color.FromHex(CurrentCitizenSettingDTO.WeekDayColors[1].HexColor);
            App.Current.Resources["WednesdayColor"] = Color.FromHex(CurrentCitizenSettingDTO.WeekDayColors[2].HexColor);
            App.Current.Resources["ThursdayColor"] = Color.FromHex(CurrentCitizenSettingDTO.WeekDayColors[3].HexColor);
            App.Current.Resources["FridayColor"] = Color.FromHex(CurrentCitizenSettingDTO.WeekDayColors[4].HexColor);
            App.Current.Resources["SaturdayColor"] = Color.FromHex(CurrentCitizenSettingDTO.WeekDayColors[5].HexColor);
            App.Current.Resources["SundayColor"] = Color.FromHex(CurrentCitizenSettingDTO.WeekDayColors[6].HexColor);
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