using System;

using Business.Logic.Layer.Interfaces.Startup;

using Tests.Unit.StructureMapTests.Jobs;
using Tests.Unit.StructureMapTests.Schedulers;

namespace Tests.Unit.StructureMapTests.Schedules
{
    public abstract class BaseSchedule<TJob> : IRunAtStartup where TJob : IJobbie
    {
        private readonly IScheduler _scheduler;

        protected BaseSchedule(IScheduler scheduler)
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