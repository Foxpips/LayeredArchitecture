using System.Web.Mvc;

using Framework.Layer.Handlers;

using SqlAgentUIRunner.Infrastructure.Manager;

using TaskRunner.Core.Reflector;

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
            return Json(SafeExecutionHandler.Try(() => _messageManager.BuildMessagesModel()));
        }

        public JsonResult GetProperties(string selectedMessage)
        {
            return Json(SafeExecutionHandler.Try(() => _messageManager.BuildPropertiesModel(selectedMessage)));
        }

        public JsonResult SendMessage(string typeName, PropertyWithValue[] propertiesForMessage)
        {
            return SafeExecutionHandler.Try(() =>
            {
                _messageManager.SendMessage(typeName, propertiesForMessage);
                return Json(new {Message = "Sent message " + typeName + "successfully"});
            });
        }
    }
}