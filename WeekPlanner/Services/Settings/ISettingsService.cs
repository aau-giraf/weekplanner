using IO.Swagger.Model;

namespace WeekPlanner.Services.Settings
{
    public interface ISettingsService
    {
        string BaseEndpoint { get; set; }
        bool UseMocks { get; set; }
        string GuardianAuthToken { get; set; }
        string CitizenAuthToken { get; set; }
        
        string CurrentCitizenId { get; set; }
        
        void UseTokenFor(UserType userType);
    }

    public enum UserType
    {
        Citizen,
        Guardian
    }
}