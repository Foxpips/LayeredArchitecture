using System;

using Framework.Layer.Handlers;

using NUnit.Framework;

namespace Tests.Library.Framework.Layer.Tests.ExecutionTests
{
    [TestFixture]
    public class SafeExecution_Tests
    {
        [Test]
        public void SafeExecution_TryCatch_WithResultTest()
        {
            Assert.That(() => SafeExecutionHandler.Try(() =>
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
                SafeExecutionHandler.Try(() =>
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
            Assert.That(() => SafeExecutionHandler.Try(() =>
            {
                throw new NullReferenceException();
                return "Test";
            }), Throws.TypeOf<NullReferenceException>());
        }

        [Test]
        public void SafeExecution_TryCatch_WithCatch_Returned_Test()
        {
            try
            {
                SafeExecutionHandler.Try(() =>
                {
                    throw new NullReferenceException();
                    return "Test";
                });
            }
            catch (Exception ex)
            {
                Assert.That(ex, Is.InstanceOf(typeof (NullReferenceException)));
            }
        }
    }
}