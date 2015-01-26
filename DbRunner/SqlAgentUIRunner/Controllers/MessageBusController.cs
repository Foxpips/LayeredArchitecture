using System.Web.Mvc;

using SqlAgentUIRunner.Infrastructure.Manager;

using TaskRunner.Core.Reflector;

namespace SqlAgentUIRunner.Controllers
{
    public class MessageBusController : Controller
    {
        private readonly ServiceBusMessageManager _messageManager = new ServiceBusMessageManager(
            new TaskRunnerReflector(),
            @"c:\Users\smarkey\Documents\GitHub\LayeredArchitecture\TaskRunner.Common\bin\Debug\TaskRunner.Common.dll");

        public ActionResult Index()
        {
            return View();
        }

        public JsonResult GetMessages()
        {
            return Json(_messageManager.BuildMessagesModel());
        }

        public JsonResult GetProperties(string selectedMessage)
        {
            return Json(_messageManager.BuildPropertiesModel(selectedMessage));
        }

        public JsonResult SendMessage(string typeName, PropertyWithValue[] propertiesForMessage)
        {
            _messageManager.SendMessage(typeName, propertiesForMessage);

            return Json(new {success = true});
        }
    }
}