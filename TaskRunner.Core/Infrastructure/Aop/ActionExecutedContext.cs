using System;
using System.Collections.Generic;

namespace TaskRunner.Core.Infrastructure.Aop
{
    public class ActionExecutedContext : ActionFilterContextBase
    {
        public ActionExecutedContext(IDictionary<string, object> messagePropertyValues, Type messageType)
            : base(messagePropertyValues)
        {
            MessageType = messageType;
        }

        public Type MessageType { get; private set; }
    }
}