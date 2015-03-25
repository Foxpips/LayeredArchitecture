using System.ServiceProcess;

using Business.Logic.Layer.Interfaces.Logging;

using Dependency.Resolver;
using Dependency.Resolver.Containers;
using Dependency.Resolver.Registries;

using Rhino.ServiceBus;
using Rhino.ServiceBus.Impl;

using StructureMap;
using StructureMap.Configuration.DSL;

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
            CustomContainer.AddRegistries<Registry>(new QuartzRegistry());

            new OnewayRhinoServiceBusConfiguration()
                .UseStructureMap(ObjectFactory.Container)
                .Configure();

            _customLogger.Info("Started scheduler service..");
        }

        protected override void OnStop()
        {
        }
    }
}