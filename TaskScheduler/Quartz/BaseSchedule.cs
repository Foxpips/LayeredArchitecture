using System;

using Business.Logic.Layer.Interfaces.Logging;
using Business.Logic.Layer.Interfaces.Startup;

using Core.Library.Helpers;

using Quartz;

using StructureMap;

namespace TaskScheduler.Quartz
{
    public abstract class BaseSchedule<TJob> : IRunAtStartup where TJob : IJob
    {
        private readonly IScheduler _scheduler;
        private readonly ICustomLogger _customLogger;

        protected BaseSchedule(IScheduler scheduler)
        {
            _customLogger = ObjectFactory.Container.GetInstance<ICustomLogger>();
            _scheduler = scheduler;
        }

        protected abstract TriggerBuilder CreateTrigger();
        protected abstract QuartzGroups QuartzGroupName { get; set; }

        public void Execute()
        {
            var jobName = typeof (TJob).Name;
            var jobKey = new JobKey(jobName, QuartzGroupName.ToString());
            var triggerName = jobName + "-Trigger";

            var jobDetail = JobBuilder.Create<TJob>()
                .WithIdentity(jobKey)
                .Build();

            var trigger = CreateTrigger()
                .ForJob(jobDetail)
                .WithIdentity(triggerName)
                .Build();

            SafeExecutionHelper.ExecuteSafely<SchedulerException>(() =>
            {
                var dateTimeOffset = ScheduleJob(jobKey, jobDetail, trigger);
                _customLogger.Info("Scheduled Job:" + jobName + "\n Runs at: " + dateTimeOffset);
            });
        }

        private DateTimeOffset? ScheduleJob(JobKey jobKey, IJobDetail jobDetail, ITrigger trigger)
        {
            if (!_scheduler.CheckExists(jobKey))
            {
                return _scheduler.ScheduleJob(jobDetail, trigger);
            }
            return _scheduler.RescheduleJob(trigger.Key, trigger);
        }
    }
}