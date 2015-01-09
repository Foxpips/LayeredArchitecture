using Rhino.ServiceBus.StructureMap;

using TaskRunner.Core.Registries;

namespace TaskRunner.Core.BootStrappers
{
    public class TaskRunnerBootStrapper : StructureMapBootStrapper
    {
        protected override void ConfigureContainer()
        {
            base.ConfigureContainer();

            Container.Configure(cfg => cfg.AddRegistry<EncryptionRegistry>());
        }
    }
}