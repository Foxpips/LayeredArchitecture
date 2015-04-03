using Business.Logic.Layer.Utilities.WebApi;
using Business.Objects.Layer.Interfaces.Logging;

using Tests.Unit.Mocks.ApiMocks.Clients;
using Tests.Unit.Mocks.ApiMocks.Requests;
using Tests.Unit.Mocks.ApiMocks.Responses;

namespace Tests.Unit.Mocks.ApiMocks
{
    public class ReflectorApiMock : SafeApiBase
    {
        public ReflectorApiMock(string userName, string password, ICustomLogger logger)
            : base(userName, password, logger)
        {
        }

        public Response SendPurchaseItemRequest()
        {
            var purchaseRequest = new PurchaseRequest
            {
                Password = Password,
                UserName = UserName
            };

            return
                SafeCall<ServiceClient, PurchaseRequest, Response>((client, request) => client.SendRequest(request),
                    purchaseRequest);
        }

        public Response SendSellItemRequest()
        {
            var sellRequest = new SellRequest
            {
                Password = Password,
                UserName = UserName
            };

            return
                SafeCall<ServiceClient, SellRequest, Response>(
                    (client, request) => client.SendRequest(request), sellRequest);
        }

        public Response SendReturnItemRequest()
        {
            var returnRequest = new ReturnRequest
            {
                Password = Password,
                UserName = UserName
            };

            return
                SafeCall<ServiceClient, ReturnRequest, Response>(
                    (client, request) => client.SendRequest(request), returnRequest);
        }
    }
}