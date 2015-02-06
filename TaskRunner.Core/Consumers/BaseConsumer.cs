using System.Collections.Generic;
using System.Linq;
using System.Transactions;

using Rhino.ServiceBus;

using TaskRunner.Core.Infrastructure.Aop;

namespace TaskRunner.Core.Consumers
{
    public abstract class BaseConsumer<TMessage> : ConsumerOf<TMessage>
    {
        public void Consume(TMessage message)
        {
            var filterProvider = new FilterProvider();

            IEnumerable<IActionFilter> filters = filterProvider
                .GetFiltersForMethod<BaseConsumer<TMessage>, TMessage>(this, x => x.ConsumeInternal)
                .ToList();
            IDictionary<string, object> messagePropertyValues = filterProvider.GetMessagePropertyValues(message);

            var actionExecutingContext = new ActionExecutingContext(messagePropertyValues);
            foreach (IActionFilter filter in filters)
            {
                filter.OnActionExecuting(actionExecutingContext);
            }

            // Make sure that any connections created in the ConsumeInternal method don't get enrolled to the
            // transaction that Rhino ESB creates to read messages from msmq.
            // This way we avoid having one distributed transaction (2 DTCs involved).
            using (var tx = new TransactionScope(TransactionScopeOption.Suppress))
            {
                ConsumeInternal(message);

                tx.Complete();
            }

            var actionExecutedContext = new ActionExecutedContext(messagePropertyValues, typeof (TMessage));
            foreach (IActionFilter filter in filters)
            {
                filter.OnActionExecuted(actionExecutedContext);
            }
        }

        [TrackDuration]
        protected abstract void ConsumeInternal(TMessage message);
    }
}