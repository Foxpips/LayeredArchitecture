using System.Data.Entity.Core;
using System.Web.Mvc;

using Business.Logic.Layer.Managers.ServiceBus;
using Business.Logic.Layer.Models.TaskRunner;

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
            return
                Json(
                    SafeExecutionHelper.ExecuteSafely<TaskRunnerMessagesModel, MappingException>(
                        () => _messageManager.BuildMessagesModel()));
        }

        public JsonResult GetProperties(string selectedMessage)
        {
            return
                Json(
                    SafeExecutionHelper.ExecuteSafely<TaskRunnerPropertiesModel, MappingException>(
                        () => _messageManager.BuildPropertiesModel(selectedMessage)));
        }

        public JsonResult SendMessage(string typeName, TaskRunnerPropertyModel[] propertiesForMessage)
        {
            return SafeExecutionHelper.ExecuteSafely<JsonResult, MappingException>(() =>
            {
                _messageManager.SendMessage(typeName, propertiesForMessage);
                return Json(new {Message = "Sent message " + typeName + " successfully"});
            });
        }
    }
}