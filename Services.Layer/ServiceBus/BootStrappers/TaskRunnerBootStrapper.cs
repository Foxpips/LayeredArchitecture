using Rhino.ServiceBus.StructureMap;

using Service.Layer.ServiceBus.Registries;

namespace Service.Layer.ServiceBus.BootStrappers
{
    public class TaskRunnerBootStrapper : StructureMapBootStrapper
    {
        protected override void ConfigureContainer()
        {
            base.ConfigureContainer();
            Container.Configure(cfg => cfg.AddRegistry(new EncryptionRegistry()));
        }
    }
}