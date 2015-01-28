using Core.Library.Utilities.WebApi;

using Tests.Library.Mocks.ApiMocks.Clients;
using Tests.Library.Mocks.ApiMocks.Requests;
using Tests.Library.Mocks.ApiMocks.Responses;

namespace Tests.Library.Mocks.ApiMocks
{
    public class ReflectorApiMock : SafeApiBase
    {
        public ReflectorApiMock(string userName, string password)
            : base(userName, password)
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
                SafeCall<ServiceClient, PurchaseRequest, Response>(
                    (client, request) => client.SendRequest(request), purchaseRequest);
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