namespace WeekPlanner
{
    public class GlobalSettings
    {
        public const string DefaultEndpoint = "http://localhost:5000";

        private string _baseEndpoint;
        private static readonly GlobalSettings _instance = new GlobalSettings();

        public GlobalSettings()
        {
            BaseEndpoint = DefaultEndpoint;
        }

        public static GlobalSettings Instance
        {
            get { return _instance; }
        }

        public string BaseEndpoint
        {
            get { return _baseEndpoint; }
            set
            {
                _baseEndpoint = value;
                UpdateEndpoint(_baseEndpoint);
            }
        }

        public bool UseMocks = true;

        public string LoginEndpoint { get; set; }

        public string LogoutEndpoint { get; set; }

        public string DepartmentAuthToken { get; set; }
        
        public string CitizenAuthToken { get; set; }

        public int CurrentDepartment { get; set; } = 1; // TODO: Make dynamic

        private void UpdateEndpoint(string baseEndpoint)
        {
            LoginEndpoint = $"{baseEndpoint}/Account/login";
            LogoutEndpoint = $"{baseEndpoint}/Account/logout";
        }
    }
}
