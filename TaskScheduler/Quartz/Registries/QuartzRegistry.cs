using Quartz;
using Quartz.Impl;
using Quartz.Spi;

using StructureMap;
using StructureMap.Configuration.DSL;

namespace TaskScheduler.Quartz.Registries
{
    public class QuartzRegistry : Registry
    {
        public QuartzRegistry(IContainer container)
        {
            For<IJobFactory>().Use(() => new QuartzJobFactory(container));
            For<IScheduler>().Singleton().Use(() =>
            {
                var stdSchedulerFactory = new StdSchedulerFactory();
                stdSchedulerFactory.Initialize();

                var scheduler = stdSchedulerFactory.GetScheduler();

                scheduler.JobFactory = container.GetInstance<IJobFactory>();

                return scheduler;
            });
        }
    }
}