//using Core.Library.Helpers;

using Business.Logic.Layer.Helpers;

using StructureMap;

namespace Dependency.Resolver.BootStrappers
{
    public class JsonHelperBootStrapper : BootStrapperBase
    {
        public override void ConfigureContainer(IContainer container)
        {
            container.Configure(cfg => cfg.AddType(typeof (JsonHelper)));
        }
    }
}