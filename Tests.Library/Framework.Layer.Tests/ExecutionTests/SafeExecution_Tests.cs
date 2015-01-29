using System;

using Core.Library.Helpers;

using NUnit.Framework;

namespace Tests.Library.Framework.Layer.Tests.ExecutionTests
{
    [TestFixture]
    public class SafeExecutionTests
    {
        [Test]
        public void SafeExecution_TryCatch_WithResultTest()
        {
            Assert.That(() => SafeExecutionHelper.Try(() =>
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
                SafeExecutionHelper.Try(() =>
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
            Assert.That(() => SafeExecutionHelper.Try(() =>
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
                SafeExecutionHelper.Try(() =>
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