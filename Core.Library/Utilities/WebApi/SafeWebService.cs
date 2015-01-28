using System;
using System.Web.Services;

using Core.Library.Exceptions.Basic;

using Framework.Layer.Logging;

namespace Core.Library.Utilities.WebApi
{
    public class SafeWebService : WebService
    {
        public CustomLogger Logger { get; set; }

        public SafeWebService()
        {
            Logger = new CustomLogger();
        }

        protected TType Execute<TType>(Func<TType> request)
        {
            try
            {
                return request();
            }
            catch (ApiSoapException ex)
            {
                Logger.Log(msg => msg.Error(ex));
                throw;
            }
            catch (ApiException ex)
            {
                Logger.Log(msg => msg.Error(ex));
                throw;
            }
            catch (Exception ex)
            {
                Logger.Log(msg => msg.Error(ex));
                throw;
            }
        }
    }
}