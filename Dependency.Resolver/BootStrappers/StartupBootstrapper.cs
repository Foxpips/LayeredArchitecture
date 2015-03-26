using Business.Logic.Layer.Interfaces.Logging;
using Business.Logic.Layer.Interfaces.Startup;
using Business.Logic.Layer.Pocos.StartupTypes;

using Framework.Layer.Logging.LogTypes;

using StructureMap;

namespace Dependency.Resolver.BootStrappers
{
    public class StartupBootstrapper : BootStrapperBase
    {
        public StartupBootstrapper(IContainer container) : base(container)
        {
        }

        public override IContainer ConfigureContainer()
        {
            Container.Configure(cfg =>
            {
                cfg.For<IRunAtStartup>().Use<StartUpType>();
                cfg.For<ICustomLogger>().Transient().Use(scope => new Log4NetFileLogger());
            });

            return Container;
        }
    }
}