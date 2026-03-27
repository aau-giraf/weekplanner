using Microsoft.AspNetCore.Http;

namespace GirafAPI.Services;

/// <summary>
/// Maps ServiceResult to HTTP responses. Single source of truth for error-to-status-code mapping.
/// </summary>
public static class ServiceResultExtensions
{
    public static IResult ToHttpResult<T>(this ServiceResult<T> result, Func<T, IResult> onSuccess) =>
        result.IsSuccess ? onSuccess(result.Value!) : MapError(result.Error!);

    public static IResult ToHttpResult(this ServiceResult result, Func<IResult> onSuccess) =>
        result.IsSuccess ? onSuccess() : MapError(result.Error!);

    private static IResult MapError(ServiceError error) =>
        error.Kind switch
        {
            ServiceErrorKind.NotFound => TypedResults.NotFound(error.Message),
            ServiceErrorKind.Validation => TypedResults.BadRequest(error.Message),
            ServiceErrorKind.Unauthorized => TypedResults.Unauthorized(),
            ServiceErrorKind.Forbidden => TypedResults.Problem(error.Message, statusCode: StatusCodes.Status403Forbidden),
            _ => TypedResults.Problem(error.Message,
                statusCode: StatusCodes.Status500InternalServerError)
        };
}
