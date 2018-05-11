using System.Collections.Generic;
using System.Threading.Tasks;
using IO.Swagger.Api;
using IO.Swagger.Client;
using IO.Swagger.Model;

namespace WeekPlanner.Services.Mocks
{
    public class MockWeekApi : IWeekApi
    {
        public Configuration Configuration { get; set; }
        public string GetBasePath()
        {
            throw new System.NotImplementedException();
        }

        public ExceptionFactory ExceptionFactory { get; set; }
        public ResponseIEnumerableWeekDTO V1WeekByWeekYearByWeekNumberDelete(int? weekYear, int? weekNumber)
        {
            throw new System.NotImplementedException();
        }

        public ApiResponse<ResponseIEnumerableWeekDTO> V1WeekByWeekYearByWeekNumberDeleteWithHttpInfo(int? weekYear, int? weekNumber)
        {
            throw new System.NotImplementedException();
        }

        public ResponseWeekDTO V1WeekByWeekYearByWeekNumberGet(int? weekYear, int? weekNumber)
        {
            throw new System.NotImplementedException();
        }

        public ApiResponse<ResponseWeekDTO> V1WeekByWeekYearByWeekNumberGetWithHttpInfo(int? weekYear, int? weekNumber)
        {
            throw new System.NotImplementedException();
        }

        public ResponseWeekDTO V1WeekByWeekYearByWeekNumberPut(int? weekYear, int? weekNumber, WeekDTO newWeek = null)
        {
            throw new System.NotImplementedException();
        }

        public ApiResponse<ResponseWeekDTO> V1WeekByWeekYearByWeekNumberPutWithHttpInfo(int? weekYear, int? weekNumber, WeekDTO newWeek = null)
        {
            throw new System.NotImplementedException();
        }

        public ResponseIEnumerableWeekNameDTO V1WeekGet()
        {
            throw new System.NotImplementedException();
        }

        public ApiResponse<ResponseIEnumerableWeekNameDTO> V1WeekGetWithHttpInfo()
        {
            throw new System.NotImplementedException();
        }

        public Task<ResponseIEnumerableWeekDTO> V1WeekByWeekYearByWeekNumberDeleteAsync(int? weekYear, int? weekNumber)
        {
            throw new System.NotImplementedException();
        }

        public Task<ApiResponse<ResponseIEnumerableWeekDTO>> V1WeekByWeekYearByWeekNumberDeleteAsyncWithHttpInfo(int? weekYear, int? weekNumber)
        {
            throw new System.NotImplementedException();
        }

        public Task<ResponseWeekDTO> V1WeekByWeekYearByWeekNumberGetAsync(int? weekYear, int? weekNumber)
        {
            throw new System.NotImplementedException();
        }

        public Task<ApiResponse<ResponseWeekDTO>> V1WeekByWeekYearByWeekNumberGetAsyncWithHttpInfo(int? weekYear, int? weekNumber)
        {
            throw new System.NotImplementedException();
        }

        public Task<ResponseWeekDTO> V1WeekByWeekYearByWeekNumberPutAsync(int? weekYear, int? weekNumber, WeekDTO newWeek = null)
        {
            throw new System.NotImplementedException();
        }

        public Task<ApiResponse<ResponseWeekDTO>> V1WeekByWeekYearByWeekNumberPutAsyncWithHttpInfo(int? weekYear, int? weekNumber, WeekDTO newWeek = null)
        {
            throw new System.NotImplementedException();
        }

        public Task<ResponseIEnumerableWeekNameDTO> V1WeekGetAsync()
        {
            throw new System.NotImplementedException();
        }

        public Task<ApiResponse<ResponseIEnumerableWeekNameDTO>> V1WeekGetAsyncWithHttpInfo()
        {
            throw new System.NotImplementedException();
        }
    }
}
