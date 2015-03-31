using System.ServiceProcess;

using Business.Objects.Layer.Interfaces.Logging;

using Dependency.Resolver.Loaders;

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
            var container = ObjectFactory.Container;
            new DependencyManager(container).AddRegistries<Registry>(new QuartzRegistry());

            new OnewayRhinoServiceBusConfiguration()
                .UseStructureMap(container)
                .Configure();

            _customLogger.Info("Started scheduler service..");
        }

        protected override void OnStop()
        {
        }
    }
}