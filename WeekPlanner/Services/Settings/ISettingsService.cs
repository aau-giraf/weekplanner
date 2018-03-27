namespace WeekPlanner.Services.Settings
{
    public interface ISettingsService
    {
        bool UseMocks { get; set; }
        
        string DepartmentAuthToken { get; set; }
        string CitizenAuthToken { get; set; }

        void UseTokenFor(TokenType tokenType);

        int CurrentDepartment { get; set; }
    }

    public enum TokenType
    {
        Citizen,
        Department
    }
}