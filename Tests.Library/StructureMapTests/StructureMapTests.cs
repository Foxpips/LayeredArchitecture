using Business.Logic.Layer.Interfaces.Startup;

using Dependency.Resolver.Loaders;

using NUnit.Framework;

using StructureMap;

using Tests.Unit.StructureMapTests.Schedulers;

namespace Tests.Unit.StructureMapTests
{
    public class StructureMapTests
    {
        [SetUp]
        public void Setup()
        {
            ObjectFactory.Container.Configure(cfg => cfg.For<IContainer>().Use(scope => ObjectFactory.Container));
            DependencyManager.ConfigureStartupDependencies();
        }

        [Test]
        public void TestRecursive_Type_Resolution()
        {
            var runAtStartup = ObjectFactory.Container.GetInstance<IRunAtStartup>();
            runAtStartup.Execute();
        }

        [Test]
        public void Test_ResolutionOfBaseClassDependencies_ThroughDerivedClass()
        {
            var container = InitialiseDependencies();

            foreach (IRunAtStartup task in container.GetAllInstances<IRunAtStartup>())
            {
                task.Execute();
            }
        }

        public Container InitialiseDependencies()
        {
            return new Container(cfg =>
            {
                cfg.For<IScheduler>().Use<CustomScheduler>();
                cfg.Scan(scan =>
                {
                    scan.TheCallingAssembly();
                    scan.AddAllTypesOf<IRunAtStartup>();
                });
            });
        }
    }
}