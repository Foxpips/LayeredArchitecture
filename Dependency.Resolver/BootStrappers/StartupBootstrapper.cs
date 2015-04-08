using Business.Objects.Layer.Interfaces.Startup;
using Business.Objects.Layer.Pocos.StartupTypes;

using StructureMap;

namespace Dependency.Resolver.BootStrappers
{
    public class StartupBootstrapper : BootStrapperBase
    {
        public override void ConfigureContainer(IContainer container)
        {
            container.Configure(cfg =>
            {
                cfg.For<IRunAtStartup>().Use<StartUpType>();
//                cfg.For<ICustomLogger>().Transient().Use(scope => new Log4NetFileLogger());
            });
        }
    }
}