using System;
using IO.Swagger.Api;
using IO.Swagger.Model;

namespace WeekPlanner.Services.Settings
{
    public class SettingsService : ISettingsService
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

        public DepartmentDTO Department
        {
            get => GlobalSettings.Instance.Department;
            set => GlobalSettings.Instance.Department = value;
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
                    break;
                case UserType.Department:
                    SetAuthTokenInAccountApi(DepartmentAuthToken);
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