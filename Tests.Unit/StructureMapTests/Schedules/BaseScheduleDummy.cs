using System;

using Business.Objects.Layer.Interfaces.Startup;

using Tests.Unit.StructureMapTests.Jobs;
using Tests.Unit.StructureMapTests.Schedulers;

namespace Tests.Unit.StructureMapTests.Schedules
{
    public abstract class BaseScheduleDummy<TJob> : IRunAtStartup where TJob : IJobbie
    {
        private readonly IScheduler _scheduler;

        protected BaseScheduleDummy(IScheduler scheduler)
        {
            _scheduler = scheduler;
        }

        protected abstract string CreateTrigger();

        public void Execute()
        {
            var job = typeof (TJob);

            Console.WriteLine("Creating Job" + job.Name);
            Console.WriteLine("With Trigger: " + CreateTrigger());

            _scheduler.ScheduleJob(job.Name);
        }
    }
}