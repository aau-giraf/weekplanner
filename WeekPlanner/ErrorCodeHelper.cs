using System;
using static IO.Swagger.Model.ResponseGirafUserDTO;

namespace WeekPlanner
{
    public static class ErrorCodeHelper
    {
        public static string ToFriendlyString(this ErrorKeyEnum? errorCode)
        {
            switch (errorCode)
            {
                case ErrorKeyEnum.InvalidCredentials:
                    return "Forkert login.";
                case ErrorKeyEnum.MissingProperties:
                    return "Du mangler at udfylde nogle felter.";
                case ErrorKeyEnum.UserMustBeGuardian:
                    return "Brugeren skal være en værge.";
                default:
                    return "Der skete en fejl.";
            }
        }
    }
}
