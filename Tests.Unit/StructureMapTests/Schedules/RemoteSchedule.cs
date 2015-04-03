using Tests.Unit.StructureMapTests.Jobs;
using Tests.Unit.StructureMapTests.Schedulers;

namespace Tests.Unit.StructureMapTests.Schedules
{
    public class RemoteSchedule : BaseSchedule<DataJob>
    {
        public RemoteSchedule(IScheduler scheduler)
            : base(scheduler)
        {
        }

        protected override string CreateTrigger()
        {
            return "Remote Trigger";
        }
    }
}