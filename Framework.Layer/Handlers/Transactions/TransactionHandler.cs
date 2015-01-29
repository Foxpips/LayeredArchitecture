using System;
using System.Transactions;

using Framework.Layer.Handlers.Methods;

namespace Framework.Layer.Handlers.Transactions
{
    public class TransactionHandler
    {
        public static void Begin(Action work)
        {
            using (new TransactionScope(TransactionScopeOption.Required,
                new TransactionOptions
                {
                    IsolationLevel = IsolationLevel.ReadCommitted,
                    Timeout = TransactionManager.MaximumTimeout
                }))
            {
                SafeExecutionHandler.Try(work);
            }
        }
    }
}