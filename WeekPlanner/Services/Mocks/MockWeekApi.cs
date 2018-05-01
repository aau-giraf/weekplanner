using System.Collections.Generic;
using System.Threading.Tasks;
using IO.Swagger.Api;
using IO.Swagger.Client;
using IO.Swagger.Model;

namespace WeekPlanner.Services.Mocks
{
    public class MockWeekApi : IWeekApi
    {
        public Configuration Configuration { get => throw new System.NotImplementedException(); set => throw new System.NotImplementedException(); }
        public ExceptionFactory ExceptionFactory { get => throw new System.NotImplementedException(); set => throw new System.NotImplementedException(); }

        public string GetBasePath()
        {
            throw new System.NotImplementedException();
        }

        public ResponseIEnumerableWeekDTO V1WeekByIdDelete(long? id)
        {
            throw new System.NotImplementedException();
        }

        public Task<ResponseIEnumerableWeekDTO> V1WeekByIdDeleteAsync(long? id)
        {
            throw new System.NotImplementedException();
        }

        public Task<ApiResponse<ResponseIEnumerableWeekDTO>> V1WeekByIdDeleteAsyncWithHttpInfo(long? id)
        {
            throw new System.NotImplementedException();
        }

        public ApiResponse<ResponseIEnumerableWeekDTO> V1WeekByIdDeleteWithHttpInfo(long? id)
        {
            throw new System.NotImplementedException();
        }

        public ResponseWeekDTO V1WeekByIdGet(long? id)
        {
            throw new System.NotImplementedException();
        }

        public Task<ResponseWeekDTO> V1WeekByIdGetAsync(long? id)
        {
            throw new System.NotImplementedException();
        }

        public Task<ApiResponse<ResponseWeekDTO>> V1WeekByIdGetAsyncWithHttpInfo(long? id)
        {
            throw new System.NotImplementedException();
        }

        public ApiResponse<ResponseWeekDTO> V1WeekByIdGetWithHttpInfo(long? id)
        {
            throw new System.NotImplementedException();
        }

        public ResponseWeekDTO V1WeekByIdPut(long? id, WeekDTO newWeek = null)
        {
            throw new System.NotImplementedException();
        }

        public Task<ResponseWeekDTO> V1WeekByIdPutAsync(long? id, WeekDTO newWeek = null)
        {
            throw new System.NotImplementedException();
        }

        public Task<ApiResponse<ResponseWeekDTO>> V1WeekByIdPutAsyncWithHttpInfo(long? id, WeekDTO newWeek = null)
        {
            throw new System.NotImplementedException();
        }

        public ApiResponse<ResponseWeekDTO> V1WeekByIdPutWithHttpInfo(long? id, WeekDTO newWeek = null)
        {
            throw new System.NotImplementedException();
        }

        public ResponseIEnumerableWeekNameDTO V1WeekGet()
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

        public ApiResponse<ResponseIEnumerableWeekNameDTO> V1WeekGetWithHttpInfo()
        {
            throw new System.NotImplementedException();
        }

        public ResponseWeekDTO V1WeekPost(WeekDTO newWeek = null)
        {
            throw new System.NotImplementedException();
        }

        public Task<ResponseWeekDTO> V1WeekPostAsync(WeekDTO newWeek = null)
        {
            throw new System.NotImplementedException();
        }

        public Task<ApiResponse<ResponseWeekDTO>> V1WeekPostAsyncWithHttpInfo(WeekDTO newWeek = null)
        {
            throw new System.NotImplementedException();
        }

        public ApiResponse<ResponseWeekDTO> V1WeekPostWithHttpInfo(WeekDTO newWeek = null)
        {
            throw new System.NotImplementedException();
        }
    }
}
