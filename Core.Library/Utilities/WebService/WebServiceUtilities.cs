using System;
using System.Web.Services.Protocols;
using System.Xml;

using Framework.Layer.Logging;

namespace Core.Library.Utilities.WebService
{
    public class WebServiceUtilities
    {
        protected TResponse SafeCall<TClient, TRequest, TResponse>(
            Func<TClient, TRequest, TResponse> work, TRequest validateRequest)
            where TClient : IDisposable, new()
        {
            using (var client = new TClient())
            {
                try
                {
                    return work(client, validateRequest);
                }
                catch (SoapException soap)
                {
                    new CustomLogger().Log(log => log.Error(soap));
                    throw new ApiSoapException(soap.Message, new XmlQualifiedName("SafeCall"), soap.InnerException);
                }
                catch (Exception ex)
                {
                    new CustomLogger().Log(log => log.Error(ex));
                    throw new ApiException(ex.Message, new XmlQualifiedName("SafeCall"), ex.InnerException);
                }
            }
        }
    }

    public class ApiException : Exception
    {
        public ApiException(string message, XmlQualifiedName xmlQualifiedName, Exception innerException)
        {
        }
    }

    public class ApiSoapException : Exception
    {
        public ApiSoapException(string message, XmlQualifiedName xmlQualifiedName, Exception innerException)
        {
        }
    }
}