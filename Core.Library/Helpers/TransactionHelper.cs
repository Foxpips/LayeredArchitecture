using System;
using System.Transactions;

using Business.Logic.Layer.Interfaces.Logging;

using Framework.Layer.Logging.LogTypes;

namespace Core.Library.Helpers
{
    public class TransactionHelper
    {
        public static void Begin(Action work, ICustomLogger logger = null)
        {
            logger = logger ?? new ConsoleLogger();

            using (var scope = new TransactionScope(TransactionScopeOption.Required,
                new TransactionOptions
                {
                    IsolationLevel = IsolationLevel.ReadCommitted,
                    Timeout = TransactionManager.MaximumTimeout
                }))
            {
                SafeExecutionHelper.ExecuteSafely<TransactionAbortedException>(logger, work);
                scope.Complete();
            }
        }
    }
}