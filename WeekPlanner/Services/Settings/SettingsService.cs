using System;
using IO.Swagger.Api;

namespace WeekPlanner.Services.Settings
{
    class SettingsService : ISettingsService
    {
        private readonly IAccountApi  _accountApi;

        public SettingsService(IAccountApi accountApi)
        {
            _accountApi = accountApi;
        }
        
        public bool UseMocks
        {
            get => GlobalSettings.Instance.UseMocks;
            set => GlobalSettings.Instance.UseMocks = value;
        }

        public string DepartmentAuthToken
        {
            get => GlobalSettings.Instance.DepartmentAuthToken;
            set => GlobalSettings.Instance.DepartmentAuthToken = value;
        }

        public string CitizenAuthToken
        {
            get => GlobalSettings.Instance.CitizenAuthToken;
            set => GlobalSettings.Instance.CitizenAuthToken = value;
        }

        public int CurrentDepartment
        {
            get => GlobalSettings.Instance.CurrentDepartment;
            set => GlobalSettings.Instance.CurrentDepartment = value;
        }

        public void UseTokenFor(TokenType tokenType)
        {
            switch(tokenType)
            {
                case TokenType.Citizen:
                    SetAuthTokenInAccountApi(CitizenAuthToken);
                    break;
                case TokenType.Department:
                    SetAuthTokenInAccountApi(DepartmentAuthToken);
                    break;
                default:
                    throw new ArgumentOutOfRangeException(nameof(tokenType), tokenType, null);
            }
        }

        private void SetAuthTokenInAccountApi(string authToken)
        {
            if (string.IsNullOrEmpty(authToken))
            {
                throw new ArgumentException("Can not be null or empty.", nameof(authToken));
            }
            _accountApi.Configuration.AddApiKey("Authorization", $"bearer {authToken}");
        }
    }
}