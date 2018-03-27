using IO.Swagger.Api;
using IO.Swagger.Client;
using IO.Swagger.Model;
using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;

namespace WeekPlanner.Services.Mocks
{
    public class WeekMockService : IWeekApi
    {
        public Configuration Configuration { get => throw new NotImplementedException(); set => throw new NotImplementedException(); }
        public ExceptionFactory ExceptionFactory { get => throw new NotImplementedException(); set => throw new NotImplementedException(); }

        public string GetBasePath()
        {
            throw new NotImplementedException();
        }

        public ResponseIEnumerableWeekDTO V1WeekByIdDelete(long? id)
        {
            throw new NotImplementedException();
        }

        public Task<ResponseIEnumerableWeekDTO> V1WeekByIdDeleteAsync(long? id)
        {
            throw new NotImplementedException();
        }

        public Task<ApiResponse<ResponseIEnumerableWeekDTO>> V1WeekByIdDeleteAsyncWithHttpInfo(long? id)
        {
            throw new NotImplementedException();
        }

        public ApiResponse<ResponseIEnumerableWeekDTO> V1WeekByIdDeleteWithHttpInfo(long? id)
        {
            throw new NotImplementedException();
        }

        public ResponseWeekDTO V1WeekByIdGet(long? id)
        {
            throw new NotImplementedException();
        }

        public Task<ResponseWeekDTO> V1WeekByIdGetAsync(long? id)
        {
            throw new NotImplementedException();
        }

        public Task<ApiResponse<ResponseWeekDTO>> V1WeekByIdGetAsyncWithHttpInfo(long? id)
        {
            throw new NotImplementedException();
        }

        public ApiResponse<ResponseWeekDTO> V1WeekByIdGetWithHttpInfo(long? id)
        {
            throw new NotImplementedException();
        }

        public ResponseWeekDTO V1WeekByIdPut(long? id, WeekDTO newWeek = null)
        {
            throw new NotImplementedException();
        }

        public Task<ResponseWeekDTO> V1WeekByIdPutAsync(long? id, WeekDTO newWeek = null)
        {
            throw new NotImplementedException();
        }

        public Task<ApiResponse<ResponseWeekDTO>> V1WeekByIdPutAsyncWithHttpInfo(long? id, WeekDTO newWeek = null)
        {
            throw new NotImplementedException();
        }

        public ApiResponse<ResponseWeekDTO> V1WeekByIdPutWithHttpInfo(long? id, WeekDTO newWeek = null)
        {
            throw new NotImplementedException();
        }

        public ResponseIEnumerableWeekDTO V1WeekGet()
        {
            throw new NotImplementedException();
        }

        public Task<ResponseIEnumerableWeekDTO> V1WeekGetAsync()
        {
            throw new NotImplementedException();
        }

        public Task<ApiResponse<ResponseIEnumerableWeekDTO>> V1WeekGetAsyncWithHttpInfo()
        {
            throw new NotImplementedException();
        }

        public ApiResponse<ResponseIEnumerableWeekDTO> V1WeekGetWithHttpInfo()
        {
            throw new NotImplementedException();
        }

        public ResponseWeekDTO V1WeekPost(WeekDTO newWeek = null)
        {
            throw new NotImplementedException();
        }

        public Task<ResponseWeekDTO> V1WeekPostAsync(WeekDTO newWeek = null)
        {
            throw new NotImplementedException();
        }

        public Task<ApiResponse<ResponseWeekDTO>> V1WeekPostAsyncWithHttpInfo(WeekDTO newWeek = null)
        {
            throw new NotImplementedException();
        }

        public ApiResponse<ResponseWeekDTO> V1WeekPostWithHttpInfo(WeekDTO newWeek = null)
        {
            throw new NotImplementedException();
        }
    }
}
