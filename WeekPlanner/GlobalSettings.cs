using IO.Swagger.Model;

namespace WeekPlanner
{
    public class GlobalSettings
    {
        // If you want to use localhost in the Android emulator you must use your local IP address
        // Windows: ipconfg 
        // UNIX: ifconfig | grep inet
        public const string DefaultEndpoint = "http://web.giraf.cs.aau.dk:5050";

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
            }
        }

        public bool UseMocks = false;

        public string GuardianAuthToken { get; set; }

        public string CitizenAuthToken { get; set; }

        public DepartmentNameDTO Department { get; set; } = new DepartmentNameDTO { Name = "Egebakken" };
    }
}
