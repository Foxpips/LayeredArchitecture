using System;
using System.Transactions;

using Data.Access.Layer.EntityFramework;

using Framework.Layer.Transactions;

using NUnit.Framework;

namespace Tests.Library.Framework.Layer.Tests.TransactionTests
{
    public class TransactionHandlerTests
    {
        public class Person : IEnlistmentNotification
        {
            public string Name { get; set; }
            public int Age { get; set; }

            public void Save()
            {
            }

            public void Prepare(PreparingEnlistment preparingEnlistment)
            {
            }

            public void Commit(Enlistment enlistment)
            {
            }

            public void Rollback(Enlistment enlistment)
            {
            }

            public void InDoubt(Enlistment enlistment)
            {
            }
        }

        [Test]
        public void TransactionHandler_TestedBehavior_ExpectedResult()
        {
            var persistenceManager = new PersistenceManager();

            try
            {
                TransactionHandler.Begin(() =>
                {
                    persistenceManager.Save();
                    throw new Exception();
                });
            }
            catch (Exception)
            {
            }
        }
    }
}