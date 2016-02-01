using Business.Objects.Layer.Interfaces.Startup;
using Business.Objects.Layer.Pocos.StartupTypes;
using Dependency.Resolver.Interfaces;
using StructureMap;

namespace Dependency.Resolver.BootStrappers
{
    public class StartupBootstrapper : IDependencyBootStrapper
    {
        public void ConfigureContainer(IContainer container)
        {
            container.Configure(cfg =>
            {
                cfg.For<IRunAtStartup>().Use<StartUpType>();
            });
        }
    }
}