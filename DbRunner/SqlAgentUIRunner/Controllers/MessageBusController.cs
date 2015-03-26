using System.Data.Entity.Core;
using System.Web.Mvc;

using Business.Logic.Layer.Interfaces.Logging;
using Business.Logic.Layer.Managers.ServiceBus;
using Business.Logic.Layer.Models.TaskRunner;

using Core.Library.Helpers;

using Dependency.Resolver.Loaders;

namespace SqlAgentUIRunner.Controllers
{
    public class MessageBusController : Controller
    {
        private readonly IServiceBusMessageManager _messageManager;
        private readonly ICustomLogger _customLogger;

        public MessageBusController(IServiceBusMessageManager manager)
        {
            var dependencyManager = new DependencyManager();
            dependencyManager.ConfigureStartupDependencies();
            _customLogger = dependencyManager.Container.GetInstance<ICustomLogger>();

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
                    SafeExecutionHelper.ExecuteSafely<TaskRunnerMessagesModel, MappingException>(_customLogger,
                        () => _messageManager.BuildMessagesModel()));
        }

        public JsonResult GetProperties(string selectedMessage)
        {
            return
                Json(
                    SafeExecutionHelper.ExecuteSafely<TaskRunnerPropertiesModel, MappingException>(_customLogger,
                        () => _messageManager.BuildPropertiesModel(selectedMessage)));
        }

        public JsonResult SendMessage(string typeName, TaskRunnerPropertyModel[] propertiesForMessage)
        {
            return SafeExecutionHelper.ExecuteSafely<JsonResult, MappingException>(_customLogger, () =>
            {
                _messageManager.SendMessage(typeName, propertiesForMessage);
                return Json(new {Message = "Sent message " + typeName + " successfully"});
            });
        }
    }
}