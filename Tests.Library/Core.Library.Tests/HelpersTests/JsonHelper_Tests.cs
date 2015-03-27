using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;

using Business.Logic.Layer.Pocos.Data;
using Business.Logic.Layer.Pocos.Sql;

using Core.Library.Helpers;

using Dependency.Resolver.Loaders;

using NUnit.Framework;

namespace Tests.Unit.Core.Library.Tests.HelpersTests
{
    [TestFixture]
    public class JsonHelperTests
    {
        private JsonHelper _jsonHelper;

        [SetUp]
        public void Setup()
        {
            _jsonHelper = new DependencyManager().ConfigureStartupDependencies().GetInstance<JsonHelper>();
        }

        [Test]
        public void Test_Json_Serialize()
        {
            var item = new Book();
            string path = Path.GetFullPath(@"..\..\Core.Library.Tests\SampleJsonTests\SampleJsonTests - BookTest.json");
            _jsonHelper.SerializeJsonToFile(item, path);
            Console.WriteLine(path);
            Assert.That(File.Exists(path), Is.True);
        }

        [Test]
        public void Test_Json_Deserialize()
        {
            var book = _jsonHelper.DeserializeJsonFromFile<Book>(
                @"C:\Users\smarkey\Documents\GitHub\LayeredArchitecture\Tests.Library\Core.Library.Tests\SampleJsonTests\SampleJson.json");
            Assert.That(book, Is.Not.Null.Or.Empty);
            Assert.That(book.Name, Is.EqualTo("John Carter"));
        }

        [Test]
        public void Test_Json_Deserialize_Collection()
        {
            var books = _jsonHelper.DeserializeJsonFromFile<List<Book>>(
                @"C:\Users\smarkey\Documents\GitHub\LayeredArchitecture\Tests.Library\Core.Library.Tests\SampleJsonTests\SampleJson - Books.json");
            Assert.That(books.Any());
        }

        [Test]
        public void DeserializeJson_Test()
        {
            var testBook = new Book {Id = 10, Isbn = "213789", Name = "Harry Potter"};
            var serializeJson = _jsonHelper.SerializeJson(testBook);

            var deserializeJson = _jsonHelper.DeserializeJson<Book>(serializeJson);

            Assert.That(deserializeJson.Name.Equals(testBook.Name), Is.True);
        }

        [Test]
        public void Serialize_ServerCredentials_File()
        {
            var sqlServerCredentials = new SqlServerCredentials
            {
                ConnectionString = "server=sth3gisql;database=h3gi;uid=sa;pwd=kAnUTr@na5we;app=SqlScriptsRunner",
                ServerName = "System Test"
            };

            _jsonHelper.SerializeJsonToFile(sqlServerCredentials, @"..\..\..\Miscellaneous\Json\Servers.json");
        }
    }
}