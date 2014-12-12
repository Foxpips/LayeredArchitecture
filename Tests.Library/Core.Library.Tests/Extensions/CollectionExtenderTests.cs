using System.Collections.Generic;

using Core.Library.Extensions;

using NUnit.Framework;

namespace Tests.Library.Core.Library.Tests.Extensions
{
    public class CollectionExtenderTests
    {
        [Test]
        public static void ExtensionTest()
        {
            var dictionary = new Dictionary<int, string>();

            var collection2 = new List<KeyValuePair<int, string>>
            {
                new KeyValuePair<int, string>(1, "test")
            };

            dictionary.AddRange(collection2);

            Assert.That(dictionary.ContainsKey(1));
            Assert.That(dictionary.ContainsValue("test"));
        }
    }
}