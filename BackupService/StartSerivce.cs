using System.ServiceProcess;

namespace BackupService
{
    static class StartSerivce
    {
        public static void Main()
        {
            ServiceBase[] servicesToRun =
            { 
                new BackupService()
            };
         
            ServiceBase.Run(servicesToRun);
        }
    }
}
