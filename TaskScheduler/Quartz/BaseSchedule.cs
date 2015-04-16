using System;

using Business.Logic.Layer.Helpers;
using Business.Objects.Layer.Interfaces.Logging;
using Business.Objects.Layer.Interfaces.Startup;

using Quartz;

namespace TaskScheduler.Quartz
{
    public abstract class BaseSchedule<TJob> : IRunAtStartup where TJob : IJob
    {
        private readonly IScheduler _scheduler;
        private readonly ICustomLogger _customLogger;
        private readonly SafeExecutionHelper _safeExecutionHelper;

        protected BaseSchedule(IScheduler scheduler, ICustomLogger logger)
        {
            _customLogger = logger;
            _scheduler = scheduler;
            _safeExecutionHelper = new SafeExecutionHelper(_customLogger);
        }

        protected abstract TriggerBuilder CreateTrigger();
        protected abstract QuartzGroups QuartzGroupName { get; }

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

            _safeExecutionHelper.ExecuteSafely<SchedulerException>(() =>
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