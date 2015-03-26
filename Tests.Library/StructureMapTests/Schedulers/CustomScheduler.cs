using System;

namespace Tests.Unit.StructureMapTests.Schedulers
{
    public class CustomScheduler : IScheduler
    {
        public void ScheduleJob(string job)
        {
            Console.WriteLine("Scheduling job: " + job);
        }
    }
}