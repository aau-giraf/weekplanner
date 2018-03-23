namespace WeekPlanner.Services.Settings
{
    public interface ISettingsService
    {
        bool UseMocks { get; set; }
        
        string DepartmentAuthToken { get; set; }
        string CitizenAuthToken { get; set; }
    }
}