using System;

using Tests.Library.Mocks.ApiMocks.Requests;
using Tests.Library.Mocks.ApiMocks.Responses;

namespace Tests.Library.Mocks.ApiMocks.Clients
{
    public class ServiceClient : IDisposable
    {
        public Response SendRequest(IServiceRequest request)
        {
            return new Response {Data = request.ReturnThirdPartyResponse()};
        }

        public void Dispose()
        {
        }
    }
}