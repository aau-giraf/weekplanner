namespace WeekPlanner.Services.Settings
{
    class SettingsService : ISettingsService
    {
        public bool UseMocks {
            get => GlobalSettings.Instance.UseMocks;
            set => GlobalSettings.Instance.UseMocks = value;
        }

        public string DepartmentAuthToken { 
            get => GlobalSettings.Instance.DepartmentAuthToken;
            set => GlobalSettings.Instance.DepartmentAuthToken = value;
        }
        public string CitizenAuthToken { 
            get => GlobalSettings.Instance.CitizenAuthToken;
            set => GlobalSettings.Instance.CitizenAuthToken = value;
        }
    }
}