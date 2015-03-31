using Business.Objects.Layer.Interfaces.Startup;

using Quartz;

namespace TaskScheduler.Quartz
{
    public class QuartzService : IRunAtStartup, IRunAtShutdown
    {
        private readonly IScheduler _scheduler;

        public QuartzService(IScheduler scheduler)
        {
            _scheduler = scheduler;
        }

        void IRunAtStartup.Execute()
        {
            _scheduler.Start();
        }

        void IRunAtShutdown.Execute()
        {
            _scheduler.Shutdown(true);
        }
    }
}