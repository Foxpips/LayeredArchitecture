using Tests.Unit.StructureMapTests.Jobs;
using Tests.Unit.StructureMapTests.Schedulers;

namespace Tests.Unit.StructureMapTests.Schedules
{
    public class StdSchedule : BaseSchedule<CatalogueJob>
    {
        public StdSchedule(IScheduler scheduler) : base(scheduler)
        {
        }

        protected override string CreateTrigger()
        {
            return "Std Trigger";
        }
    }
}