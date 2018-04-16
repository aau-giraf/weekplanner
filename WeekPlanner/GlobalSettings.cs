using IO.Swagger.Model;

namespace WeekPlanner
{
    public class GlobalSettings
    {
        // If you want to use localhost in the Android emulator you must use your IPv4 address
        // Windows: ipconfg 
        // UNIX: ifconfig | grep inet
        public const string DefaultEndpoint = "http://172.25.115.203:5000";

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

        public bool UseMocks = false;

        public string DepartmentAuthToken { get; set; }

        public string CitizenAuthToken { get; set; }

        public DepartmentNameDTO Department { get; set; } = new DepartmentNameDTO { Name = "Egebakken" };
    }
}
