using System.Web;
using System.Web.Http;
using System.Web.Mvc;
using System.Web.Optimization;
using System.Web.Routing;

using Business.Objects.Layer.Interfaces.AutoMapper;

using Framework.Layer.Loaders.Mapping;

namespace Gui.Layer
{
    // Note: For instructions on enabling IIS6 or IIS7 classic mode, 
    // visit http://go.microsoft.com/?LinkId=9394801

    public class MvcApplication : HttpApplication
    {
        protected void Application_Start()
        {
            AutoMapperLoader.LoadAllMappings(typeof (IMapCustom).Assembly.ExportedTypes);

            AreaRegistration.RegisterAllAreas();

            WebApiConfig.Register(GlobalConfiguration.Configuration);
            FilterConfig.RegisterGlobalFilters(GlobalFilters.Filters);
            RouteConfig.RegisterRoutes(RouteTable.Routes);
            BundleConfig.RegisterBundles(BundleTable.Bundles);
            AuthConfig.RegisterAuth();

//            StructuremapMvc.Start();

//            ControllerBuilder.Current.SetControllerFactory(new CustomControllerFactory());
        }

//        private static void InitializeAutoMapper()
//        {
//            AutoMapperConfig.RegisterMappings();
//        }
    }
}