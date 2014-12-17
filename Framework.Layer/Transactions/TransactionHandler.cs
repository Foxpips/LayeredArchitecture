using System;
using System.Transactions;

using Framework.Layer.Handlers;

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

//        public static void Begin<TExceptionArgs>(Action work) where TExceptionArgs : ExceptionArgsBase, new()
//        {
//            using (var scope = new TransactionScope(TransactionScopeOption.Required,
//                new TransactionOptions
//                {
//                    IsolationLevel = IsolationLevel.ReadCommitted,
//                    Timeout = TransactionManager.MaximumTimeout
//                })
//                )
//            {
//                SafeExecutionHandler.Try<TExceptionArgs>(work);
//                scope.Complete();
//            }
//        }
    }
}