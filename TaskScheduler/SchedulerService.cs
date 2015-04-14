using System.ServiceProcess;

using Business.Objects.Layer.Interfaces.Logging;

using Dependency.Resolver.Loaders;

using Rhino.ServiceBus;
using Rhino.ServiceBus.Impl;

using StructureMap.Configuration.DSL;

using TaskScheduler.Quartz.Registries;

namespace TaskScheduler
{
    public partial class SchedulerService : ServiceBase
    {
        private readonly ICustomLogger _customLogger;
        private DependencyManager _dependencyManager;

        public SchedulerService(ICustomLogger customLogger)
        {
            _customLogger = customLogger;
            InitializeComponent();
        }

        protected override void OnStart(string[] args)
        {
            _dependencyManager = new DependencyManager();
            _dependencyManager.AddRegistries<Registry>(new QuartzRegistry(_dependencyManager.Container));

            new OnewayRhinoServiceBusConfiguration()
                .UseStructureMap(_dependencyManager.Container)
                .Configure();

            _customLogger.Info("Started scheduler service..");
        }

        protected override void OnStop()
        {
        }
    }
}