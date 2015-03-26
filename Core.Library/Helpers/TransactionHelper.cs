using System;
using System.Transactions;

using Business.Logic.Layer.Interfaces.Logging;

using Dependency.Resolver.Loaders;

namespace Core.Library.Helpers
{
    public class TransactionHelper
    {
        public static void Begin(Action work)
        {
            var dependencyManager = new DependencyManager();
            dependencyManager.ConfigureStartupDependencies();

            using (var scope = new TransactionScope(TransactionScopeOption.Required,
                new TransactionOptions
                {
                    IsolationLevel = IsolationLevel.ReadCommitted,
                    Timeout = TransactionManager.MaximumTimeout
                }))
            {
                SafeExecutionHelper.ExecuteSafely<TransactionAbortedException>(
                    dependencyManager.Container.GetInstance<ICustomLogger>(), work);
                scope.Complete();
            }
        }
    }
}