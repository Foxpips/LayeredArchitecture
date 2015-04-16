﻿using System.ServiceProcess;

using Business.Objects.Layer.Interfaces.Logging;
using Business.Objects.Layer.Interfaces.Startup;

using Dependency.Resolver.Registries;

using Rhino.ServiceBus;
using Rhino.ServiceBus.Impl;

using StructureMap;

using TaskScheduler.Quartz.Registries;

namespace TaskScheduler
{
    public partial class SchedulerService : ServiceBase
    {
        private readonly ICustomLogger _customLogger;

        public SchedulerService(ICustomLogger customLogger)
        {
            _customLogger = customLogger;
            InitializeComponent();
        }

        protected override void OnStart(string[] args)
        {
            _customLogger.Info("Started scheduler service..");

            var container = new Container();
            container.Configure(cfg =>
            {
                cfg.AddRegistry(new TaskRegistry());
                cfg.AddRegistry(new QuartzRegistry(container));
            });

            new OnewayRhinoServiceBusConfiguration()
                .UseStructureMap(container)
                .Configure();

            using (IContainer nestedContainer = container.GetNestedContainer())
            {
                foreach (IRunAtStartup task in nestedContainer.GetAllInstances<IRunAtStartup>())
                {
                    task.Execute();
                }
            }
        }

        protected override void OnStop()
        {
        }
    }
}