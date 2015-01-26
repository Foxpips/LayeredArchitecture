using System.Web.Mvc;
using System.Web.Mvc.Html;

namespace SqlAgentUIRunner.Infrastructure.Helpers
{
    public static class HtmlHelpers
    {
        public static MvcHtmlString MenuLink(
            this HtmlHelper htmlHelper, string linkText, string actionName, string controllerName)
        {
            string currentAction = htmlHelper.ViewContext.RouteData.GetRequiredString("action");
            string currentController = htmlHelper.ViewContext.RouteData.GetRequiredString("controller");

            var builder = new TagBuilder("li")
            {
                InnerHtml = htmlHelper.ActionLink(linkText, actionName, controllerName).ToHtmlString()
            };

            if (controllerName == currentController && actionName == currentAction)
            {
                builder.AddCssClass("active");
            }

            return new MvcHtmlString(builder.ToString());
        }
    }
}