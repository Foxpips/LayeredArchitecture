using Business.Logic.Layer.Interfaces.Startup;

using Dependency.Resolver.Loaders;

using NUnit.Framework;

using Tests.Unit.StructureMapTests.Schedulers;

namespace Tests.Unit.StructureMapTests
{
    public class StructureMapTests
    {
        private DependencyManager _dependencyManager;

        [SetUp]
        public void Setup()
        {
            _dependencyManager = new DependencyManager();
            _dependencyManager.ConfigureStartupDependencies();
        }

        [Test]
        public void TestRecursive_Type_Resolution()
        {
            var runAtStartup = _dependencyManager.Container.GetInstance<IRunAtStartup>();
            runAtStartup.Execute();
        }

        [Test]
        public void Test_ResolutionOfBaseClassDependencies_ThroughDerivedClass()
        {
            InitialiseDependencies();

            foreach (IRunAtStartup task in _dependencyManager.Container.GetAllInstances<IRunAtStartup>())
            {
                task.Execute();
            }
        }

        public void InitialiseDependencies()
        {
            _dependencyManager.Container.EjectAllInstancesOf<IRunAtStartup>();
            _dependencyManager.Container.Configure((cfg =>
            {
                cfg.For<IScheduler>().Use<CustomScheduler>();
                cfg.Scan(scan =>
                {
                    scan.TheCallingAssembly();
                    scan.AddAllTypesOf<IRunAtStartup>();
                });
            }));
        }
    }
}