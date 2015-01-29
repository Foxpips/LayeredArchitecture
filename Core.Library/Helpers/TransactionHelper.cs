using System;
using System.Transactions;

namespace Core.Library.Helpers
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
                SafeExecutionHelper.Try(work);
                scope.Complete();
            }
        }
    }
}