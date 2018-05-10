using IO.Swagger.Model;

namespace WeekPlanner.Helpers
{
    public static class PictoToWeekPictoDtoHelper
    {
        public static WeekPictogramDTO Convert(PictogramDTO picto) {
            return new WeekPictogramDTO
            {
                Id = picto.Id,
                AccessLevel = (WeekPictogramDTO.AccessLevelEnum)picto.AccessLevel,
                ImageHash = picto.ImageHash,
                ImageUrl = picto.ImageUrl,
                LastEdit = picto.LastEdit,
                Title = picto.Title,
            };
        }
    }
}