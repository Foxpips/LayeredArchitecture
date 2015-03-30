using System;
using System.Web.Services;

using Business.Logic.Layer.Exceptions.Basic;
using Business.Logic.Layer.Interfaces.Logging;

namespace Core.Library.Utilities.WebApi
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