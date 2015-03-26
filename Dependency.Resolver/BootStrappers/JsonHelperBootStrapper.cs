using Business.Logic.Layer.Interfaces.IoC;

using Core.Library.Helpers;

using StructureMap;

namespace Dependency.Resolver.BootStrappers
{
    public class JsonHelperBootStrapper : BootStrapperBase
    {
        public JsonHelperBootStrapper(IContainer container) : base(container)
        {
        }

        public override IContainer ConfigureContainer()
        {
            Container.Configure(cfg => cfg.For<IJsonHelper>().Use<JsonHelper>());
            return Container;
        }
    }
}