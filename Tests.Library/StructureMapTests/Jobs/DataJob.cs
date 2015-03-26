using System;

namespace Tests.Unit.StructureMapTests.Jobs
{
    public class DataJob : IJobbie
    {
        public void Run()
        {
            Console.WriteLine("Running DataJob");
        }
    }
}