using System;
using System.Web.Services;

using Business.Objects.Layer.Exceptions.Basic;
using Business.Objects.Layer.Interfaces.Logging;

namespace Business.Logic.Layer.Utilities.WebApi
{
    public class SafeWebService : WebService
    {
        private ICustomLogger Logger { get; set; }

        protected SafeWebService(ICustomLogger logger)
        {
            Logger = logger;
        }

        protected TType Execute<TType>(Func<TType> request)
        {
            try
            {
                return request();
            }
            catch (ApiSoapException ex)
            {
                Logger.Error(ex);
                throw;
            }
            catch (ApiException ex)
            {
                Logger.Error(ex);
                throw;
            }
            catch (Exception ex)
            {
                Logger.Error(ex);
                throw;
            }
        }
    }
}