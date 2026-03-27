using Microsoft.AspNetCore.Diagnostics;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace GirafAPI.Configuration;

/// <summary>
/// Catches BadHttpRequestException (model binding failures) and returns a clean 400
/// instead of leaking stack traces or internal type names.
/// </summary>
public sealed class BadRequestExceptionHandler : IExceptionHandler
{
    public async ValueTask<bool> TryHandleAsync(
        HttpContext httpContext, Exception exception, CancellationToken cancellationToken)
    {
        if (exception is not BadHttpRequestException badRequest)
            return false;

        httpContext.Response.StatusCode = StatusCodes.Status400BadRequest;
        await httpContext.Response.WriteAsJsonAsync(new ProblemDetails
        {
            Status = StatusCodes.Status400BadRequest,
            Title = "Bad Request",
            Detail = "The request body could not be parsed. Check that the JSON structure matches the expected format.",
            Type = "https://tools.ietf.org/html/rfc9110#section-15.5.1"
        }, cancellationToken);

        return true;
    }
}
