namespace TaskRunner.Core.Infrastructure.Aop
{
    public interface IActionFilter
    {
        void OnActionExecuting(ActionExecutingContext context);
        void OnActionExecuted(ActionExecutedContext context);
    }
}