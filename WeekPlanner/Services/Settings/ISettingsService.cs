using System.Threading.Tasks;
using IO.Swagger.Model;


namespace WeekPlanner.Services.Settings
{
    public interface ISettingsService
    {
        string BaseEndpoint { get; set; }
        string AuthToken { get; set; }
        bool IsInGuardianMode { get; set; }
        SettingDTO CurrentCitizenSettingDTO { get; set; }
        GirafUserDTO CurrentCitizen { get; set; }
        void SetTheme();
    }


    public enum UserType
    {
        Citizen,
        Guardian
    }
}