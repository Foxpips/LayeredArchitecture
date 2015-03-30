using System;
using System.Data.Entity.Core;
using System.Linq;
using System.Web.Mvc;

using AutoMapper;

using Business.Logic.Layer.Interfaces.Logging;
using Business.Logic.Layer.Interfaces.ServiceBus;
using Business.Logic.Layer.Models.TaskRunner;
using Business.Logic.Layer.Pocos.Reflection;

using Core.Library.Extensions;
using Core.Library.Helpers;

using Rhino.ServiceBus;

namespace SqlAgentUIRunner.Controllers
{
    public class MessageBusController : Controller
    {
        private readonly IServiceBusMessageManager _messageManager;
        private readonly ICustomLogger _customLogger;
        private readonly IOnewayBus _bus;

        public MessageBusController(IServiceBusMessageManager manager, ICustomLogger logger, IOnewayBus bus)
        {
            _bus = bus;
            _customLogger = logger;
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
                var messageType = _messageManager.GetMessage(typeName);

                if (propertiesForMessage != null && propertiesForMessage.Any())
                {
                    SendMessageWithBus(messageType, Mapper.Map<PropertyWithValue[]>(propertiesForMessage));
                }
                else
                {
                    SendMessageWithBus(messageType);
                }

                return Json(new {Message = "Sent message " + typeName + " successfully"});
            });
        }

        private void SendMessageWithBus(Type messageType, PropertyWithValue[] props = null)
        {
            _customLogger.Info("Sending message: " + messageType.Name + " using service bus.");

            var instance = Activator.CreateInstance(messageType);
            if (props != null)
            {
                instance.SetPublicProperties(props);
            }

            _bus.Send(instance);
            _customLogger.Info("Message sent successfully!");
        }
    }
}