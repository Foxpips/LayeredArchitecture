﻿using System;
using System.ServiceProcess;

using Business.Logic.Layer.Interfaces.Logging;

using Dependency.Resolver.Loaders;

using StructureMap;

namespace TaskScheduler
{
    internal static class StartScheduler
    {
        private static ICustomLogger _customLogger;

        static StartScheduler()
        {
            new DependencyManager(ObjectFactory.Container).ConfigureStartupDependencies();
        }

        private static void Main()
        {
            _customLogger = ObjectFactory.Container.GetInstance<ICustomLogger>();
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