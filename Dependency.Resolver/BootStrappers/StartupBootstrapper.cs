using Business.Logic.Layer.Interfaces.Logging;
using Business.Logic.Layer.Interfaces.Startup;
using Business.Logic.Layer.Pocos.StartupTypes;

using Framework.Layer.Logging.LogTypes;

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
                cfg.For<ICustomLogger>().Transient().Use(scope => new Log4NetFileLogger());
            });
        }
    }
}