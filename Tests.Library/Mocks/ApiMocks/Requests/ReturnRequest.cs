using System;
using System.Web.Services.Protocols;
using System.Xml;

namespace Tests.Unit.Mocks.ApiMocks.Requests
{
    public class ReturnRequest : IServiceRequest
    {
        public string UserName { get; set; }
        public string Password { get; set; }

        public string ReturnThirdPartyResponse()
        {
            throw new SoapException("Api Exception", new XmlQualifiedName(), new Exception());
            return "Success";
        }
    }
}