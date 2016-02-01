//using Core.Library.Helpers;

using Business.Logic.Layer.Helpers;
using Dependency.Resolver.Interfaces;
using StructureMap;

namespace Dependency.Resolver.BootStrappers
{
    public class JsonHelperBootStrapper : IDependencyBootStrapper
    {
        public void ConfigureContainer(IContainer container)
        {
            container.Configure(cfg => cfg.AddType(typeof (JsonHelper)));
        }
    }
}