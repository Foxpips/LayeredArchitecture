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

                //                new SafeExecutionHelper(logger ?? new ConsoleLogger()).ExecuteSafely<TransactionAbortedException>(
                //                    ExceptionPolicy.RethrowException,
                //                    work,
                //                    (ex, log) => log.Fatal(ex.Message));
            }
        }
    }
}