using System;

using Framework.Layer.Loaders.Resource;
using Framework.Layer.Logging;

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
    }
}