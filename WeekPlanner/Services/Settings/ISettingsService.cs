using System.Threading.Tasks;
using IO.Swagger.Model;


namespace WeekPlanner.Services.Settings
{
    public interface ISettingsService
    {
        string BaseEndpoint { get; set; }
        bool UseMocks { get; set; }
        string AuthToken { get; set; }
        bool IsInGuardianMode { get; set; }
        string CurrentCitizenId { get; set; }
        string CurrentCitizenName { get; set; }
        SettingDTO CurrentCitizenSettingDTO { get; set; }
        void SetTheme();
    }


    public enum UserType
    {
        Citizen,
        Guardian
    }
}