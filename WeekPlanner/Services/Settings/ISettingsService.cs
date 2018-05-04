using System.Threading.Tasks;
using IO.Swagger.Model;


namespace WeekPlanner.Services.Settings
{
    public interface ISettingsService
    {
        string BaseEndpoint { get; set; }
        bool UseMocks { get; set; }
        string GuardianAuthToken { get; set; }
        string CitizenAuthToken { get; set; }
        bool IsInGuardianMode { get; set; }
        
        string CurrentCitizenId { get; set; }
        SettingDTO CurrentCitizenSettingDTO { get; set; }
        
        void UseTokenFor(UserType userType);
        void SetThemeOnLogin();
    }


    public enum UserType
    {
        Citizen,
        Guardian
    }
}