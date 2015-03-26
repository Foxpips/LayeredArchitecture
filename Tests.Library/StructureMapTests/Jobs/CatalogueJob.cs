using System;

namespace Tests.Unit.StructureMapTests.Jobs
{
    public class CatalogueJob : IJobbie
    {
        public void Run()
        {
            Console.WriteLine("Running CatalogueJob");
        }
    }
}