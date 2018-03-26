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

        public ResponseIEnumerableWeekDTO V1WeekByIdDelete(int? id)
        {
            throw new NotImplementedException();
        }

        public Task<ResponseIEnumerableWeekDTO> V1WeekByIdDeleteAsync(int? id)
        {
            throw new NotImplementedException();
        }

        public Task<ApiResponse<ResponseIEnumerableWeekDTO>> V1WeekByIdDeleteAsyncWithHttpInfo(int? id)
        {
            throw new NotImplementedException();
        }

        public ApiResponse<ResponseIEnumerableWeekDTO> V1WeekByIdDeleteWithHttpInfo(int? id)
        {
            throw new NotImplementedException();
        }

        public ResponseWeekDTO V1WeekByIdGet(int? id)
        {
            throw new NotImplementedException();
        }

        public Task<ResponseWeekDTO> V1WeekByIdGetAsync(int? id)
        {
            throw new NotImplementedException();
        }

        public Task<ApiResponse<ResponseWeekDTO>> V1WeekByIdGetAsyncWithHttpInfo(int? id)
        {
            throw new NotImplementedException();
        }

        public ApiResponse<ResponseWeekDTO> V1WeekByIdGetWithHttpInfo(int? id)
        {
            throw new NotImplementedException();
        }

        public ResponseWeekDTO V1WeekByIdPut(int? id, WeekDTO newWeek = null)
        {
            throw new NotImplementedException();
        }

        public Task<ResponseWeekDTO> V1WeekByIdPutAsync(int? id, WeekDTO newWeek = null)
        {
            throw new NotImplementedException();
        }

        public Task<ApiResponse<ResponseWeekDTO>> V1WeekByIdPutAsyncWithHttpInfo(int? id, WeekDTO newWeek = null)
        {
            throw new NotImplementedException();
        }

        public ApiResponse<ResponseWeekDTO> V1WeekByIdPutWithHttpInfo(int? id, WeekDTO newWeek = null)
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
