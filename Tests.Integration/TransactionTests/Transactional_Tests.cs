using System;
using System.Linq;

using Business.Logic.Layer.Helpers;
using Business.Objects.Layer.Exceptions.Generic;
using Business.Objects.Layer.Exceptions.Generic.Args;
using Business.Objects.Layer.Pocos.Data;

using Data.Access.Layer.EntityFramework.Contexts;
using Data.Access.Layer.EntityFramework.Managers;

using NUnit.Framework;

namespace Tests.Integration.TransactionTests
{
    public class RollbackOnExceptionTransactionalTests
    {
        [Test]
        public void ThrowCustomException_DatabaseError_ConfirmRollBackSuccessful()
        {
            var dbManager = new DbManager<BooksContext>();

            var bookInitialCount = 0;

            //Cant use this as we need log4net 1.2.13 and that doesnt work with rhino service bus for some unknown reason.
//            Assert.Throws<CustomException<DatabaseErrorExceptionArgs>>(() => before = TestSqlConnection_AddNewBookthenRollback_ReturnBookInitialCount());

            try
            {
                bookInitialCount = TestSqlConnection_AddNewBookthenRollback_ReturnBookInitialCount();
            }
            catch (Exception ex)
            {
                Assert.That(ex.GetType() == typeof (CustomException<DatabaseErrorExceptionArgs>));
            }

            dbManager.Connect(data =>
            {
                var after = data.Books.Count();
                Assert.That(bookInitialCount == after);
            });
        }

        private static int TestSqlConnection_AddNewBookthenRollback_ReturnBookInitialCount()
        {
            var dbManager = new DbManager<BooksContext>();
            var before = 0;
            dbManager.Connect(database =>
            {
                try
                {
                    TransactionHelper.Begin(() =>
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