using Quartz;
using Quartz.Impl;
using Quartz.Spi;

using StructureMap;
using StructureMap.Configuration.DSL;

namespace TaskScheduler.Quartz.Registries
{
    public class QuartzRegistry : Registry
    {
        public QuartzRegistry()
        {
            For<IJobFactory>().Use(() => new QuartzJobFactory(ObjectFactory.Container));
            For<IScheduler>().Singleton().Use(() =>
            {
                var stdSchedulerFactory = new StdSchedulerFactory();
                stdSchedulerFactory.Initialize();

                var scheduler = stdSchedulerFactory.GetScheduler();

                scheduler.JobFactory = ObjectFactory.Container.GetInstance<IJobFactory>();

                return scheduler;
            });
        }
    }
}