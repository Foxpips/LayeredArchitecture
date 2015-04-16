using System;

using Business.Objects.Layer.Interfaces.Logging;

using Quartz;

using Rhino.ServiceBus;

using TaskRunner.Common.Messages.Test;

using TaskScheduler.Quartz;

namespace TaskScheduler.Schedules
{
    public class HelloWorldSchedule : BaseSchedule<HelloWorldJob>
    {
        public HelloWorldSchedule(IScheduler scheduler, ICustomLogger logger) : base(scheduler, logger)
        {
        }

        protected override TriggerBuilder CreateTrigger()
        {
            return TriggerBuilder.Create().WithSimpleSchedule(x => x.WithInterval(TimeSpan.FromSeconds(10)));
        }

        protected override QuartzGroups QuartzGroupName
        {
            get { return QuartzGroups.Every5Minutes; }
        }
    }

    public class HelloWorldJob : IJob
    {
        private readonly IOnewayBus _bus;

        public HelloWorldJob(IOnewayBus bus)
        {
            _bus = bus;
        }

        public void Execute(IJobExecutionContext context)
        {
            _bus.Send(new HelloWorldCommand());
        }
    }
}