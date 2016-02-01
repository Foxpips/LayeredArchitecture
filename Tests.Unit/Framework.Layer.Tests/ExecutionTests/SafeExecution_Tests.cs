using System;

using Business.Logic.Layer.Helpers;
using Business.Objects.Layer.Interfaces.Execution;
using Business.Objects.Layer.Interfaces.Logging;

using Dependency.Resolver.Loaders;

using NUnit.Framework;

namespace Tests.Unit.Framework.Layer.Tests.ExecutionTests
{
    [TestFixture]
    public class SafeExecutionTests
    {
        private SafeExecutionHelper _safeExecutionHelper;

        [SetUp]
        public void Setup()
        {
            using (
                var customLogger =
                    new DependencyManager().ConfigureStartupDependencies(ContainerType.Nested)
                        .GetInstance<ICustomLogger>())
            {
                _safeExecutionHelper = new SafeExecutionHelper(customLogger);
            }
        }

        [Test]
        public void SafeExecution_TryCatch_WithResultTest()
        {
            Assert.That(() => _safeExecutionHelper.ExecuteSafely<NullReferenceException>(() =>
            {
                Console.WriteLine("");
                throw new NullReferenceException();
            }), Throws.TypeOf<NullReferenceException>());
        }

        [Test]
        public void SafeExecution_TryCatch_WithCatchTest()
        {
            try
            {
                _safeExecutionHelper.ExecuteSafely<NullReferenceException>(() =>
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
                    _safeExecutionHelper.ExecuteSafely<NullReferenceException>(
                        () => { throw new NullReferenceException(); }, ExceptionPolicy.SwallowException),
                !Throws.TypeOf<NullReferenceException>());
        }

        [Test]
        public void SafeExecution_TryCatch_WithCatch_Returned_Test()
        {
            try
            {
                _safeExecutionHelper.ExecuteSafely<NullReferenceException>(
                    () => { throw new NullReferenceException(); });
            }
            catch (Exception ex)
            {
                Assert.That(ex, Is.InstanceOf(typeof (NullReferenceException)));
            }
        }
    }
}