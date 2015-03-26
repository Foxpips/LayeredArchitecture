using Business.Logic.Layer.Interfaces.Logging;
using Business.Logic.Layer.Interfaces.Startup;
using Business.Logic.Layer.Pocos.StartupTypes;

using Framework.Layer.Logging.LogTypes;

using StructureMap;

namespace Dependency.Resolver.Registries
{
    public class StartupBootstrapper : IDependencyBootStrapper
    {
        private readonly IContainer _container;

        public StartupBootstrapper(IContainer container)
        {
            _container = container;
        }

        public IContainer ConfigureContainer()
        {
            _container.Configure(cfg =>
            {
                cfg.For<IRunAtStartup>().Use<StartUpType>();
                cfg.For<ICustomLogger>().Transient().Use(scope => new Log4NetFileLogger());
            });

            return _container;
        }
    }
}