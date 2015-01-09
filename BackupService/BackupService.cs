using System.ServiceProcess;

using BackupService.Common.Ioc;

using TaskRunner.Core;

namespace BackupService
{
    partial class BackupService : ServiceBase
    {

     public BackupService()
        {
            InitializeComponent();
        }

       protected override void OnStart(string[] args)
        {
          ServiceBus.StartServiceBus<BackupRunnerBootStrapper>();
        }
    }
}
