using System;

using Business.Logic.Layer.Interfaces.Logging;

using Core.Library.Helpers;

using Dependency.Resolver.Loaders;

using NUnit.Framework;

namespace Tests.Unit.Framework.Layer.Tests.ExecutionTests
{
    [TestFixture]
    public class SafeExecutionTests
    {
        private DependencyManager _dependencyManager;
        private ICustomLogger _customLogger;

        [SetUp]
        public void Setup()
        {
            _dependencyManager = new DependencyManager();
            _dependencyManager.ConfigureStartupDependencies();
            _customLogger = _dependencyManager.Container.GetInstance<ICustomLogger>();
        }

        [Test]
        public void SafeExecution_TryCatch_WithResultTest()
        {
            Assert.That(() => SafeExecutionHelper.ExecuteSafely<NullReferenceException>(_customLogger, () =>
            {
                Console.WriteLine("");
                throw new NullReferenceException();
            }), !Throws.TypeOf<NullReferenceException>());
        }

        [Test]
        public void SafeExecution_TryCatch_WithCatchTest()
        {
            try
            {
                SafeExecutionHelper.ExecuteSafely<NullReferenceException>(_customLogger, () =>
                {
                    Console.WriteLine("");
                    throw new NullReferenceException();
                });
            }
            catch (Exception ex)
            {
                Assert.That(ex, Is.InstanceOf(typeof (NullReferenceException)));
            }
        }

        [Test]
        public void SafeExecution_TryCatch_WithResultReturned_Test()
        {
            Assert.That(
                () =>
                    SafeExecutionHelper.ExecuteSafely<NullReferenceException>(_customLogger,
                        () => { throw new NullReferenceException(); }), !Throws.TypeOf<NullReferenceException>());
        }

        [Test]
        public void SafeExecution_TryCatch_WithCatch_Returned_Test()
        {
            try
            {
                SafeExecutionHelper.ExecuteSafely<NullReferenceException>(_customLogger,
                    () => { throw new NullReferenceException(); });
            }
            catch (Exception ex)
            {
                Assert.That(ex, Is.InstanceOf(typeof (NullReferenceException)));
            }
        }
    }
}