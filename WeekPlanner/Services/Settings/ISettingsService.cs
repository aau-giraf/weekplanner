using IO.Swagger.Model;

namespace WeekPlanner.Services.Settings
{
    public interface ISettingsService
    {
        bool UseMocks { get; set; }
        string GuardianAuthToken { get; set; }
        string CitizenAuthToken { get; set; }
        void UseTokenFor(UserType userType);

    }

    public enum UserType
    {
        Citizen,
        Guardian
    }
}