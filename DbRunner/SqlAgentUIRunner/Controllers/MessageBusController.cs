using System.Web.Mvc;

using Business.Logic.Layer.Managers.ServiceBus;
using Business.Objects.Layer.Models.TaskRunnerModels;

using Core.Library.Helpers;

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