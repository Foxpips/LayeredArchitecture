using Quartz;
using Quartz.Spi;

using StructureMap;

namespace TaskScheduler.Quartz
{
    public class QuartzJobFactory : IJobFactory
    {
        private readonly IContainer _container;

        public QuartzJobFactory(IContainer container)
        {
            _container = container;
        }

        public IJob NewJob(TriggerFiredBundle bundle, IScheduler scheduler)
        {
            return _container.GetInstance(bundle.JobDetail.JobType) as IJob;
        }

        public void ReturnJob(IJob job)
        {
        }
    }
}