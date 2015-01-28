using System;
using System.Web.Services.Protocols;
using System.Xml;

using Core.Library.Exceptions.Basic;

using Framework.Layer.Logging;

namespace Core.Library.Utilities.WebApi
{
    public abstract class SafeApiBase
    {
        protected string UserName { get; set; }
        protected string Password { get; set; }

        protected SafeApiBase(string userName, string password)
        {
            UserName = userName;
            Password = password;
        }

        public TResponse SafeCall<TClient, TRequest, TResponse>(
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
}