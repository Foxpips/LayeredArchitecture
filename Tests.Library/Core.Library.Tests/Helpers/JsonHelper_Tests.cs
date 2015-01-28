using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;

using Business.Logic.Layer.Pocos;

using Core.Library.Helpers;

using NUnit.Framework;

namespace Tests.Library.Core.Library.Tests.Helpers
{
    [TestFixture]
    public class JsonHelperTests
    {
        [Test]
        public void Test_Json_Serialize()
        {
            var item = new Book();
            string path = Path.GetFullPath(@"..\..\Core.Library.Tests\SampleJson\SampleJson - BookTest.json");
            JsonHelper.SerializeJson(item, path);
            Console.WriteLine(path);
            Assert.That(File.Exists(path), Is.True);
        }

        [Test]
        public void Test_Json_Deserialize()
        {
            var book = JsonHelper.DeserializeJson<Book>("SampleJson.json",
                @"C:\Users\smarkey\Documents\GitHub\LayeredArchitecture\Tests.Library\Core.Library.Tests\SampleJson");
            Assert.That(book, Is.Not.Null.Or.Empty);
            Assert.That(book.Name, Is.EqualTo("John Carter"));
        }

        [Test]
        public void Test_Json_Deserialize_Collection()
        {
            var books = JsonHelper.DeserializeJson<List<Book>>("SampleJson - Books.json",
                @"C:\Users\smarkey\Documents\GitHub\LayeredArchitecture\Tests.Library\Core.Library.Tests\SampleJson");
            Assert.That(books.Any());
        }

        [Test]
        public void DeserializeJson_Test()
        {
            var testBook = new Book {Id = 10, Isbn = "213789", Name = "Harry Potter"};
            var serializeJson = JsonHelper.SerializeJson(testBook);

            var deserializeJson = JsonHelper.DeserializeJson<Book>(serializeJson);

            Assert.That(deserializeJson.Name.Equals(testBook.Name), Is.True);
        }
    }
}