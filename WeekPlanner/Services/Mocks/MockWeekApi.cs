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
        public ResponseIEnumerableWeekDTO V1WeekByIdDelete(long? id)
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

        public ApiResponse<ResponseWeekDTO> V1WeekByIdGetWithHttpInfo(long? id)
        {
            throw new System.NotImplementedException();
        }

        public ResponseWeekDTO V1WeekByIdPut(long? id, WeekDTO newWeek = null)
        {
            throw new System.NotImplementedException();
        }

        public ApiResponse<ResponseWeekDTO> V1WeekByIdPutWithHttpInfo(long? id, WeekDTO newWeek = null)
        {
            throw new System.NotImplementedException();
        }

        public ResponseIEnumerableWeekDTO V1WeekGet()
        {
            throw new System.NotImplementedException();
        }

        public ApiResponse<ResponseIEnumerableWeekDTO> V1WeekGetWithHttpInfo()
        {
            throw new System.NotImplementedException();
        }

        public ResponseWeekDTO V1WeekPost(WeekDTO newWeek = null)
        {
            throw new System.NotImplementedException();
        }

        public ApiResponse<ResponseWeekDTO> V1WeekPostWithHttpInfo(WeekDTO newWeek = null)
        {
            throw new System.NotImplementedException();
        }

        public async Task<ResponseIEnumerableWeekDTO> V1WeekByIdDeleteAsync(long? id)
        {
            throw new System.NotImplementedException();
        }

        public async Task<ApiResponse<ResponseIEnumerableWeekDTO>> V1WeekByIdDeleteAsyncWithHttpInfo(long? id)
        {
            throw new System.NotImplementedException();
        }

        public async Task<ResponseWeekDTO> V1WeekByIdGetAsync(long? id)
        {
            List<WeekdayDTO> days = new List<WeekdayDTO>();
            for (int i = 0; i < 7; i++)
            {
                WeekdayDTO w = new WeekdayDTO() {Day = (WeekdayDTO.DayEnum) i, Elements = new List<ResourceDTO>()};
                WeekdayDTO.DayEnum d = (WeekdayDTO.DayEnum)i;
                for (int j = 0; j < 5; j++)
                {
                    w.Elements.Add(new ResourceDTO(Title:"asd", Id: 1+j*i));
                }
                days.Add(w);
            }
            return new ResponseWeekDTO
            {
                Data = new WeekDTO(){Days = days},
                Success = true,
                ErrorKey = ResponseWeekDTO.ErrorKeyEnum.NoError,
            };
        }

        public async Task<ApiResponse<ResponseWeekDTO>> V1WeekByIdGetAsyncWithHttpInfo(long? id)
        {
            throw new System.NotImplementedException();
        }

        public async Task<ResponseWeekDTO> V1WeekByIdPutAsync(long? id, WeekDTO newWeek = null)
        {
            throw new System.NotImplementedException();
        }

        public async Task<ApiResponse<ResponseWeekDTO>> V1WeekByIdPutAsyncWithHttpInfo(long? id, WeekDTO newWeek = null)
        {
            throw new System.NotImplementedException();
        }

        public async Task<ResponseIEnumerableWeekDTO> V1WeekGetAsync()
        {
            List<WeekdayDTO> days = new List<WeekdayDTO>();
            for (int i = 0; i < 7; i++)
            {
                WeekdayDTO w = new WeekdayDTO() {Day = (WeekdayDTO.DayEnum) i, Elements = new List<ResourceDTO>()};
                WeekdayDTO.DayEnum d = (WeekdayDTO.DayEnum)i;
                for (int j = 0; j < 5; j++)
                {
                    w.Elements.Add(new ResourceDTO(){Id = j+i});
                }
                days.Add(w);
            }

            WeekDTO week = new WeekDTO() {Days = days};
            return new ResponseIEnumerableWeekDTO()
            {
                Success = true,
                ErrorKey = ResponseIEnumerableWeekDTO.ErrorKeyEnum.NoError,
                Data = new List<WeekDTO>(){week}
            };
        }

        public async Task<ApiResponse<ResponseIEnumerableWeekDTO>> V1WeekGetAsyncWithHttpInfo()
        {
            throw new System.NotImplementedException();
        }

        public async Task<ResponseWeekDTO> V1WeekPostAsync(WeekDTO newWeek = null)
        {
            throw new System.NotImplementedException();
        }

        public async Task<ApiResponse<ResponseWeekDTO>> V1WeekPostAsyncWithHttpInfo(WeekDTO newWeek = null)
        {
            throw new System.NotImplementedException();
        }

        ResponseIEnumerableWeekNameDTO IWeekApi.V1WeekGet()
        {
            throw new System.NotImplementedException();
        }

        ApiResponse<ResponseIEnumerableWeekNameDTO> IWeekApi.V1WeekGetWithHttpInfo()
        {
            throw new System.NotImplementedException();
        }

        Task<ResponseIEnumerableWeekNameDTO> IWeekApi.V1WeekGetAsync()
        {
            throw new System.NotImplementedException();
        }

        Task<ApiResponse<ResponseIEnumerableWeekNameDTO>> IWeekApi.V1WeekGetAsyncWithHttpInfo()
        {
            throw new System.NotImplementedException();
        }
    }
}