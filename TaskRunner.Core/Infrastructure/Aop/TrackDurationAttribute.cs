using System.Diagnostics;
using System.Reflection;

using Common.Logging;

namespace TaskRunner.Core.Infrastructure.Aop
{
    public class TrackDurationAttribute : ActionFilterAttribute
    {
        private static readonly ILog _logger = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
        private Stopwatch _stopwatch;

        public override void OnActionExecuting(ActionExecutingContext context)
        {
            _stopwatch = Stopwatch.StartNew();
        }

        public override void OnActionExecuted(ActionExecutedContext context)
        {
            _stopwatch.Stop();
            _logger.InfoFormat("Message of type [{0}] consumed in {1} ms.", context.MessageType,
                _stopwatch.ElapsedMilliseconds);
        }
    }
}