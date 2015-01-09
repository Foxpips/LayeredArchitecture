using Rhino.ServiceBus.StructureMap;

namespace BackupService.Common.Ioc
{
    public class BackupRunnerBootStrapper : StructureMapBootStrapper
    {
        protected override void ConfigureContainer()
        {
            base.ConfigureContainer();
            Container.Configure(cfg => cfg.AddRegistry(new BackupRegistry()));
        }
    }
}