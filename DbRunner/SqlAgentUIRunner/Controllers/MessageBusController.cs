using System;
using System.Data.Entity.Core;
using System.Linq;
using System.Web.Mvc;

using AutoMapper;

using Business.Logic.Layer.Extensions;
using Business.Logic.Layer.Helpers;
using Business.Objects.Layer.Interfaces.Logging;
using Business.Objects.Layer.Interfaces.ServiceBus;
using Business.Objects.Layer.Models.TaskRunner;
using Business.Objects.Layer.Pocos.Reflection;

using Rhino.ServiceBus;

using TaskRunner.Core.ServiceBus;

namespace SqlAgentUIRunner.Controllers
{
    public class MessageBusController : Controller
    {
        private readonly IServiceBusMessageManager _messageManager;
        private readonly ICustomLogger _customLogger;
        private readonly Client<IOnewayBus> _client;
        private readonly SafeExecutionHelper _safeExecutionHelper;

        public MessageBusController(IServiceBusMessageManager manager, ICustomLogger logger, Client<IOnewayBus> client)
        {
            _client = client;
            _customLogger = logger;
            _messageManager = manager;
            _safeExecutionHelper = new SafeExecutionHelper(logger);
        }

        public ActionResult Index()
        {
            return View();
        }

        public JsonResult GetMessages()
        {
            return
                Json(
                    _safeExecutionHelper.ExecuteSafely<TaskRunnerMessagesModel, MappingException>(
                        () => _messageManager.BuildMessagesModel()));
        }

        public JsonResult GetProperties(string selectedMessage)
        {
            return
                Json(
                    _safeExecutionHelper.ExecuteSafely<TaskRunnerPropertiesModel, MappingException>(
                        () => _messageManager.BuildPropertiesModel(selectedMessage)));
        }

        public JsonResult SendMessage(string typeName, TaskRunnerPropertyModel[] propertiesForMessage)
        {
            return _safeExecutionHelper.ExecuteSafely<JsonResult, MappingException>(() =>
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

        private void SendMessageWithBus(Type messageType, PropertyWithValue[] propertyValues = null)
        {
            _customLogger.Info("Sending message: " + messageType.Name + " using service bus.");
            var message = _safeExecutionHelper.ExecuteSafely<object, TypeLoadException>(() =>
            {
                var instance = Activator.CreateInstance(messageType);

                if (propertyValues != null)
                {
                    return instance.SetPublicProperties(propertyValues);
                }

                return instance;
            });

            _client.Bus.Send(message);
            _customLogger.Info("Message sent successfully!");
        }
    }
}