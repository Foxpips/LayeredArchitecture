using Business.Objects.Layer.Interfaces.Logging;

using Dependency.Resolver.Loaders;

using NUnit.Framework;

namespace Tests.Unit.Dependency.Resolver.Tests
{
    public class CustomContainerTests
    {
        [Test]
        public void CustomContainer_Add_NoInitialize()
        {
            var dependencyManager = new DependencyManager();
            dependencyManager.ConfigureStartupDependencies();

            var customLogger = dependencyManager.Container.GetInstance<ICustomLogger>();
            customLogger.Info("Test");

            Assert.True(customLogger != null);
        }
    }
}