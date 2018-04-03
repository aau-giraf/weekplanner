namespace WeekPlanner.Services.Settings
{
    public interface ISettingsService
    {
        bool UseMocks { get; set; }
        long DepartmentId { get; set; }
    }
}