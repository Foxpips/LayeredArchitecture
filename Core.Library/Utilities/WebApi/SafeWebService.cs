using System;
using System.Web.Services;

using Business.Logic.Layer.Interfaces.Logging;

using Core.Library.Exceptions.Basic;

using Dependency.Resolver.Loaders;

namespace Core.Library.Utilities.WebApi
{
    public class SafeWebService : WebService
    {
        public ICustomLogger Logger { get; set; }

        public SafeWebService()
        {
            Logger = new DependencyManager().ConfigureStartupDependencies().GetInstance<ICustomLogger>();
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