using System;
using System.Transactions;

namespace Business.Logic.Layer.Helpers
{
    public class TransactionHelper
    {
        public static void Begin(Action work)
        {
            using (var scope = new TransactionScope(TransactionScopeOption.Required,
                new TransactionOptions
                {
                    IsolationLevel = IsolationLevel.ReadCommitted,
                    Timeout = TransactionManager.MaximumTimeout
                }))
            {
                work();
                scope.Complete();
            }
        }
    }
}