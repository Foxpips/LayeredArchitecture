using System;

using Tests.Unit.Mocks.ApiMocks.Requests;
using Tests.Unit.Mocks.ApiMocks.Responses;

namespace Tests.Unit.Mocks.ApiMocks.Clients
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