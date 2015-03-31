using System;
using System.Linq;

using Business.Logic.Layer.Helpers;
using Business.Objects.Layer.Pocos.Data;

using Data.Access.Layer.EntityFramework.Contexts;
using Data.Access.Layer.EntityFramework.Managers;

using Dependency.Resolver.Loaders;

using NUnit.Framework;

using StructureMap;

namespace Tests.Integration.TransactionTests
{
    public class BloggingContextTests
    {
        [SetUp]
        public void SetUp()
        {
            new DependencyManager(ObjectFactory.Container).ConfigureStartupDependencies();
        }

        [Test]
        public void SaveBlog_Test()
        {
            var database = new BlogsManager();
            database.Truncate();
            var blog = new Blog {Name = "Test Blog"};
            var initialCount = database.Count();

            try
            {
                TransactionHelper.Begin(() => database.Save(blog));
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }

            var finalCount = database.Count();

            Assert.That(finalCount == ++initialCount);
        }

        [Test]
        public void GetBookList_Test()
        {
            var database = new BooksManager();
            try
            {
                TransactionHelper.Begin(() => database.GetList2().ForEach(book => Console.WriteLine(book.Name)));
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }
        }

        [Test]
        public void TruncateTable_Test()
        {
            var connection = new DbManager<BloggingContext>();
            connection.Connect(database =>
            {
                var dbSet = database.Blogs;
                dbSet.RemoveRange(dbSet);
                database.SaveChanges();

                Assert.That(!dbSet.Any());
            });
        }
    }
}