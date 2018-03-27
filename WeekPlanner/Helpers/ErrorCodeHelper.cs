using System;
using IO.Swagger.Model;
using static IO.Swagger.Model.Response;

namespace WeekPlanner.Helpers
{
    public static class ErrorCodeHelper
    {
        public static string ToFriendlyString(string errorCode)
        {
            switch (errorCode)
            {
                case nameof(ErrorKeyEnum.InvalidCredentials):
                    return "Forkert login.";
                case nameof(ErrorKeyEnum.MissingProperties):
                    return "Du mangler at udfylde nogle felter.";
                case nameof(ErrorKeyEnum.UserMustBeGuardian):
                    return "Brugeren skal være en værge."; 
                case nameof(ErrorKeyEnum.NotAuthorized):
                    return "Du har ikke rettigheder til denne handling";
                case nameof(ErrorKeyEnum.Error):
                    return "Ukendt fejl opstod. Måske er serveren nede.";
                case nameof(ErrorKeyEnum.WeekScheduleNotFound):
                    return "Ugeplanen kunne ikke findes";
                default:
                    throw new ArgumentOutOfRangeException(nameof(errorCode), errorCode, null);
            }
        }
        
        // We do this to avoid having to change and combine the enums from the generated Swagger code manually.
        
        public static string ToFriendlyString(this ResponseGirafUserDTO.ErrorKeyEnum? errorKey) => 
        ToFriendlyString(errorKey.ToString());

        public static string ToFriendlyString(this ResponseWeekDTO.ErrorKeyEnum? errorKey) =>
            ToFriendlyString(errorKey.ToString());
        
        public static string ToFriendlyString(this Response.ErrorKeyEnum? errorKey) =>
            ToFriendlyString(errorKey.ToString());
        
        public static string ToFriendlyString(this ResponseString.ErrorKeyEnum? errorKey) =>
            ToFriendlyString(errorKey.ToString());
        
        public static string ToFriendlyString(this ResponseChoiceDTO.ErrorKeyEnum? errorKey) =>
            ToFriendlyString(errorKey.ToString());
        
        public static string ToFriendlyString(this ResponseByte.ErrorKeyEnum? errorKey) =>
            ToFriendlyString(errorKey.ToString());
        
        public static string ToFriendlyString(this ResponseListDepartmentDTO.ErrorKeyEnum? errorKey) =>
            ToFriendlyString(errorKey.ToString());
        
        public static string ToFriendlyString(this ResponseDepartmentDTO.ErrorKeyEnum? errorKey) =>
            ToFriendlyString(errorKey.ToString());
        
        public static string ToFriendlyString(this ResponseLauncherOptions.ErrorKeyEnum? errorKey) =>
            ToFriendlyString(errorKey.ToString());
        
        public static string ToFriendlyString(this ResponseLauncherOptionsDTO.ErrorKeyEnum? errorKey) =>
            ToFriendlyString(errorKey.ToString());
        
        public static string ToFriendlyString(this ResponsePictogramDTO.ErrorKeyEnum? errorKey) =>
            ToFriendlyString(errorKey.ToString());
        
        public static string ToFriendlyString(this ResponseIEnumerableWeekDTO.ErrorKeyEnum? errorKey) =>
            ToFriendlyString(errorKey.ToString());
        
        public static string ToFriendlyString(this ResponseListPictogramDTO.ErrorKeyEnum? errorKey) =>
            ToFriendlyString(errorKey.ToString());
        
        public static string ToFriendlyString(this ResponseListUserNameDTO.ErrorKeyEnum? errorKey) =>
            ToFriendlyString(errorKey.ToString());
    }
}
