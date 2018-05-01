using System;
using System.Threading.Tasks;
using IO.Swagger.Api;
using IO.Swagger.Model;
using SimpleJson;

namespace WeekPlanner.Services.Settings
{
    public class SettingsService : ISettingsService
    {
        private readonly IAccountApi  _accountApi;
        private readonly JsonObject _appSettings;

        private static string _token;
        public static Task<string> GetToken()
        {
            return Task.FromResult(_token);
        }

        public SettingsService(IAccountApi accountApi, JsonObject appSettings)
        {
            _accountApi = accountApi;
            _appSettings = appSettings;
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
    }
}