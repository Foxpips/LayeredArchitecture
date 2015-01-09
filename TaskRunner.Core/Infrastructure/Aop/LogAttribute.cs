using System.Reflection;

using Common.Logging;

namespace TaskRunner.Core.Infrastructure.Aop
{
    public class LogAttribute : ActionFilterAttribute
    {
        private static readonly ILog _logger = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        private readonly string _executedDescription;
        private readonly string _executingDescription;

        public LogAttribute(string executingDescription, string executedDescription)
        {
            _executingDescription = executingDescription;
            _executedDescription = executedDescription;
        }

        private static void LogDescription(ActionFilterContextBase context, string description)
        {
            foreach (var messagePropertyValue in context.MessagePropertyValues)
            {
                description = description.Replace("{" + messagePropertyValue.Key + "}",
                    messagePropertyValue.Value.ToString());
            }

            _logger.Info(description);
        }

        public override void OnActionExecuting(ActionExecutingContext context)
        {
            LogDescription(context, _executingDescription);
        }

        public override void OnActionExecuted(ActionExecutedContext context)
        {
            LogDescription(context, _executedDescription);
        }
    }
}