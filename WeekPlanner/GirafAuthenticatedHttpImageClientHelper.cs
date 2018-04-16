using System;
using System.Net.Http;
using System.Threading;
using System.Threading.Tasks;

namespace WeekPlanner
{
    public class GirafAuthenticatedHttpImageClientHelper : HttpClientHandler
    {
        
        private readonly Func<Task<string>> _getToken;

        public GirafAuthenticatedHttpImageClientHelper(Func<Task<string>> getToken)
        {
            if (getToken == null) throw new ArgumentNullException("getToken");
            _getToken = getToken;
        }

        protected override async Task<HttpResponseMessage> SendAsync(HttpRequestMessage request, CancellationToken cancellationToken)
        {
            var token = await _getToken.Invoke();
            request.Headers.Add("Authorization", "bearer " + token);
            return await base.SendAsync(request, cancellationToken).ConfigureAwait(false);
        }
    }
}