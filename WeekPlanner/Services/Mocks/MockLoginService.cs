using System;
using System.Threading.Tasks;
using WeekPlanner.Services.Login;
using WeekPlanner.Services.Settings;

namespace WeekPlanner.Services.Mocks
{
    public class MockLoginService : ILoginService
    {
        private readonly ISettingsService _settingsService;
        
        public MockLoginService(ISettingsService settingsService)
        {
            _settingsService = settingsService;
        }
        
        public async Task LoginAndThenAsync(Func<Task> onSuccess, UserType userType, string username, string password = "")
        {
            if (userType == UserType.Guardian && string.IsNullOrEmpty(password))
            {
                throw new ArgumentException("A password should always be provided for Departments.");
            }
            
            // TODO: Maybe allow for only certain credentials
            
            if(userType == UserType.Citizen)
            {
                _settingsService.CitizenAuthToken = "MockCitizenAuthToken";
            }
            else // Guardian
            {
                _settingsService.GuardianAuthToken = "MockDepartmentAuthToken";
            }

            _settingsService.UseTokenFor(userType);

            await onSuccess.Invoke();
        }

        public async Task LoginAsync(UserType userType, string username, string password)
        {
            if (userType == UserType.Department && string.IsNullOrEmpty(password))
            {
                throw new ArgumentException("A password should always be provided for Departments.");
            }
            // TODO: Maybe allow for only certain credentials
            if (userType == UserType.Citizen)
            {
                _settingsService.CitizenAuthToken = "MockCitizenAuthToken";
            }
            else // Department
            {
                _settingsService.DepartmentAuthToken = "MockDepartmentAuthToken";
            }

            _settingsService.UseTokenFor(userType);
        }
    }
}