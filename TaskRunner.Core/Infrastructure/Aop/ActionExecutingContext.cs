using System.Collections.Generic;

namespace TaskRunner.Core.Infrastructure.Aop
{
    public class ActionExecutingContext : ActionFilterContextBase
    {
        public ActionExecutingContext(IDictionary<string, object> messagePropertyValues) : base(messagePropertyValues)
        {
        }
    }
}