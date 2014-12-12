using System;
using System.Transactions;

using Framework.Layer.Exceptions;

namespace Framework.Layer.Transactions
{
    public class TransactionHandler
    {
        public static void Begin(Action work)
        {
            using (var scope = new TransactionScope(TransactionScopeOption.Required,
                    new TransactionOptions
                    {
                        IsolationLevel = IsolationLevel.ReadCommitted,
                        Timeout = TransactionManager.MaximumTimeout
                    })
                )
            {
                SafeExecutionHandler.Try(work);
                scope.Complete();
            }
        }
    }
}