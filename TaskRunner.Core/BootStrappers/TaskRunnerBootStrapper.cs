using Dependency.Resolver.Registries;

using Rhino.ServiceBus.StructureMap;

using TaskRunner.Core.Infrastructure.Modules;

namespace TaskRunner.Core.BootStrappers
{
    public class TaskRunnerBootStrapper : StructureMapBootStrapper
    {
        protected override void ConfigureContainer()
        {
            base.ConfigureContainer();

            Container.Configure(cfg =>
            {
                cfg.AddRegistry<EncryptionRegistry>();
                cfg.AddRegistry<ServiceBusRegistry>();
                cfg.AddRegistry<LoggerRegistry>();
            });
        }
    }
}