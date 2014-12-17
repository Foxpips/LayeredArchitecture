using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;

using Business.Logic.Layer.Pocos;

using Core.Library.Helpers;

using NUnit.Framework;

namespace Tests.Library.Core.Library.Tests.Helpers
{
    public class JsonHelperTests
    {
        [Test]
        public void Test_Json_Serialize()
        {
            var item = new Book();
            var path = Environment.CurrentDirectory + "outputJson.json";
            JsonHelper.SerializeJson(item, path);
            Assert.That(Directory.Exists(path), Is.True);
        }

        [Test]
        public void Test_Json_Deserialize()
        {
            var book = JsonHelper.DeserializeJson<Book>("SampleJson.json",
                @"C:\Users\smarkey\Documents\GitHub\LayeredArchitecture\Tests.Library\Core.Library.Tests\SampleJson");
            Assert.That(book, Is.Not.Null.Or.Empty);
        }

        [Test]
        public void Test_Json_Deserialize_Collection()
        {
            var books = JsonHelper.DeserializeJson<List<Book>>("SampleJson.json",
                @"C:\Users\smarkey\Documents\GitHub\LayeredArchitecture\Tests.Library\Core.Library.Tests\SampleJsonList");
            Assert.That(books.Any());
        }
    }
}