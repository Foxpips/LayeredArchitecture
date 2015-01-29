using System.Web.Mvc;

using Core.Library.Helpers;

using SqlAgentUIRunner.Infrastructure.Manager;
using SqlAgentUIRunner.Models.TaskRunnerModels;

namespace SqlAgentUIRunner.Controllers
{
    public class MessageBusController : Controller
    {
        private readonly IServiceBusMessageManager _messageManager;

        public MessageBusController(IServiceBusMessageManager manager)
        {
            _messageManager = manager;
        }

        public ActionResult Index()
        {
            return View();
        }

        public JsonResult GetMessages()
        {
            return Json(SafeExecutionHelper.Try(() => _messageManager.BuildMessagesModel()));
        }

        public JsonResult GetProperties(string selectedMessage)
        {
            return Json(SafeExecutionHelper.Try(() => _messageManager.BuildPropertiesModel(selectedMessage)));
        }

        public JsonResult SendMessage(string typeName, TaskRunnerPropertyModel[] propertiesForMessage)
        {
            return SafeExecutionHelper.Try(() =>
            {
                _messageManager.SendMessage(typeName, propertiesForMessage);
                return Json(new {Message = "Sent message " + typeName + " successfully"});
            });
        }
    }
}