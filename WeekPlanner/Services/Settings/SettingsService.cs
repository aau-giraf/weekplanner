namespace WeekPlanner.Services.Settings
{
    class SettingsService : ISettingsService
    {
        public bool UseMocks {
            get => GlobalSettings.Instance.UseMocks;
            set => GlobalSettings.Instance.UseMocks = value;
        }

        public long DepartmentId
        {
            get => GlobalSettings.Instance.DepartmentId;
            set => GlobalSettings.Instance.DepartmentId = value;
        }
    }
}