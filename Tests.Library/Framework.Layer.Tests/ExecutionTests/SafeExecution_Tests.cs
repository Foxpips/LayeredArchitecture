using System;

using Core.Library.Helpers;

using Dependency.Resolver.Loaders;

using NUnit.Framework;

namespace Tests.Unit.Framework.Layer.Tests.ExecutionTests
{
    [TestFixture]
    public class SafeExecutionTests
    {
        [SetUp]
        public void Setup()
        {
            DependencyManager.ConfigureStartupDependencies();
        }

        [Test]
        public void SafeExecution_TryCatch_WithResultTest()
        {
            Assert.That(() => SafeExecutionHelper.ExecuteSafely<NullReferenceException>(() =>
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
                SafeExecutionHelper.ExecuteSafely<NullReferenceException>(() =>
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
                    SafeExecutionHelper.ExecuteSafely<NullReferenceException>(
                        () => { throw new NullReferenceException(); }), !Throws.TypeOf<NullReferenceException>());
        }

        [Test]
        public void SafeExecution_TryCatch_WithCatch_Returned_Test()
        {
            try
            {
                SafeExecutionHelper.ExecuteSafely<NullReferenceException>(() => { throw new NullReferenceException(); });
            }
            catch (Exception ex)
            {
                Assert.That(ex, Is.InstanceOf(typeof (NullReferenceException)));
            }
        }
    }
}