using System.ServiceProcess;

namespace TaskScheduler
{
    internal static class StartScheduler
    {
        /// <summary>
        /// The main entry point for the application.
        /// </summary>
        private static void Main()
        {
            ServiceBase[] servicesToRun =
            {
                new SchedulerService()
            };
            ServiceBase.Run(servicesToRun);
        }
    }
}