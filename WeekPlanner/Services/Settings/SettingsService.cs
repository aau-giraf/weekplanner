namespace WeekPlanner.Services.Settings
{
    class SettingsService : ISettingsService
    {
        public bool UseMocks {
            get => GlobalSettings.Instance.UseMocks;
            set => GlobalSettings.Instance.UseMocks = value;
        }
    }
}