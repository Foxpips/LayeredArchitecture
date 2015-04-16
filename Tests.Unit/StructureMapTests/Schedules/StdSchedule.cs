using Tests.Unit.StructureMapTests.Jobs;
using Tests.Unit.StructureMapTests.Schedulers;

namespace Tests.Unit.StructureMapTests.Schedules
{
    public class StdSchedule : BaseScheduleDummy<CatalogueJob>
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