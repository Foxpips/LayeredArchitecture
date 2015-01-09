using System.Collections.Generic;

namespace TaskRunner.Core.Infrastructure.Aop
{
    public class ActionFilterContextBase
    {
        public ActionFilterContextBase(IDictionary<string, object> messagePropertyValues)
        {
            MessagePropertyValues = messagePropertyValues;
        }

        public IDictionary<string, object> MessagePropertyValues { get; private set; }
    }
}