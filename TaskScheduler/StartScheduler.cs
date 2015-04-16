using System;
using System.ServiceProcess;

using Business.Objects.Layer.Interfaces.Logging;

using Dependency.Resolver.Loaders;

namespace TaskScheduler
{
    internal static class StartScheduler
    {
        private static readonly ICustomLogger _customLogger;

        static StartScheduler()
        {
            _customLogger = new DependencyManager().ConfigureStartupDependencies().GetInstance<ICustomLogger>();
        }

        private static void Main()
        {
            AppDomain.CurrentDomain.UnhandledException += CurrentDomain_HandleException;

            ServiceBase[] servicesToRun =
            {
                new SchedulerService(_customLogger)
            };

            _customLogger.Info("Starting scheduler service..");
            ServiceBase.Run(servicesToRun);
        }

        private static void CurrentDomain_HandleException(object sender, UnhandledExceptionEventArgs e)
        {
            _customLogger.ErrorFormat("Unhanded AppDomain exception! e.IsTerminating=[{0}].", e.IsTerminating);
            _customLogger.Error(e.ExceptionObject);
        }
    }
}