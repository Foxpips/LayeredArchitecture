namespace Tests.Unit.Mocks.ApiMocks.Requests
{
    public class SellRequest : IServiceRequest
    {
        public string UserName { get; set; }
        public string Password { get; set; }

        public string ReturnThirdPartyResponse()
        {
            return "Success";
        }
    }
}