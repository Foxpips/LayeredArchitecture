using Business.Logic.Layer.Interfaces.Logging;

using Dependency.Resolver.Loaders;
using Dependency.Resolver.Registries;

using NUnit.Framework;

using StructureMap;

namespace Tests.Unit.Dependency.Resolver.Tests
{
    public class CustomContainerTests
    {
        [Test]
        public void CustomContainer_Add_NoInitialize()
        {
            DependencyManager.AddRegistries(new LoggerRegistry());

            var customLogger = ObjectFactory.Container.GetInstance<ICustomLogger>();
            customLogger.Info("Test");

            Assert.True(customLogger != null);
        }
    }
}