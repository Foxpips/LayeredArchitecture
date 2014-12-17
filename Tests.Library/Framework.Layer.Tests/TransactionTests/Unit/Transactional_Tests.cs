using System;
using System.Linq;

using Business.Logic.Layer.Pocos;

using Data.Access.Layer.EntityFramework.Contexts;
using Data.Access.Layer.EntityFramework.Managers;

using Framework.Layer.Exceptions;
using Framework.Layer.Exceptions.Args;
using Framework.Layer.Transactions;

using NUnit.Framework;

namespace Tests.Library.Framework.Layer.Tests.TransactionTests.Unit
{
    public class TransactionalTests
    {
        [Test]
        public void TransactionTests_TestedBehavior_ExpectedResult()
        {
            var dbManager = new DbManager<BooksContext>();

            var before = 0;

            Assert.Throws<CustomException<DatabaseErrorExceptionArgs>>(() => before = TestConnection());

            dbManager.Connect(data =>
            {
                var after = data.Books.Count();
                Assert.That(before == after);
            });
        }

        private static int TestConnection()
        {
            var dbManager = new DbManager<BooksContext>();
            var before = 0;
            dbManager.Connect(database =>
            {
                try
                {
                    TransactionHandler.Begin(() =>
                    {
                        before = database.Books.Count();
                        database.Books.Add(new Book
                        {
                            Name = "Test Book",
                            Isbn = "IKS9001F"
                        });
                        database.SaveChanges();
                        throw new Exception("Database offline! please try again later");
                    });
                }
                catch (Exception ex)
                {
                    throw new CustomException<DatabaseErrorExceptionArgs>(new DatabaseErrorExceptionArgs(ex.Message));
                }
            });
            return before;
        }
    }
}