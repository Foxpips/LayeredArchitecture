using System;

using Framework.Layer.Logging;
using Framework.Layer.Logging.Resource;

using NUnit.Framework;

namespace Tests.Library.Framework.Layer.Tests.LoggingTests
{
    public class ResourceLoaderTests
    {
        [Test]
        public void GetResourceName()
        {
            string resourceName = ResourceLoader.Log4NetConfiguration();
            Console.WriteLine(resourceName);
            Assert.That(resourceName, Is.Not.Null.Or.Empty);
        }

        [Test]
        public void TestLogger_TestedBehavior_ExpectedResult()
        {
            var logger = new CustomLogger();
            logger.Log(log => log.Info("Test.."));
        }
    }
}