using System;
using System.Web.Services.Protocols;
using System.Xml;

using Business.Logic.Layer.Interfaces.Logging;

using Core.Library.Exceptions.Basic;

namespace Core.Library.Utilities.WebApi
{
    public abstract class SafeApiBase
    {
        private readonly ICustomLogger _logger;
        protected string UserName { get; set; }
        protected string Password { get; set; }

        protected SafeApiBase(string userName, string password, ICustomLogger logger)
        {
            _logger = logger;
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
                    _logger.Error(soap);
                    throw new ApiSoapException(soap.Message, new XmlQualifiedName("SafeCall"), soap.InnerException);
                }
                catch (Exception ex)
                {
                    _logger.Error(ex);
                    throw new ApiException(ex.Message, new XmlQualifiedName("SafeCall"), ex.InnerException);
                }
            }
        }
    }
}