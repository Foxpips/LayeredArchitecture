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

using Gui.Layer.Infrastructure.Factories;

namespace Gui.Layer.Controllers
{
    public class MessageBusController : Controller
    {
        private readonly IServiceBusModelBuilder _modelBuilder;
        private readonly ICustomLogger _customLogger;
        private readonly SafeExecutionHelper _safeExecutionHelper;
        private readonly MessageBusManager _messageBusManager;

        public MessageBusController(
            IServiceBusModelBuilder modelBuilder, ICustomLogger logger, MessageBusManager busManager)
        {
            _modelBuilder = modelBuilder;
            _messageBusManager = busManager;
            _customLogger = logger;
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
                        () => _modelBuilder.BuildMessagesModel()));
        }

        public JsonResult GetProperties(string selectedMessage)
        {
            return
                Json(
                    _safeExecutionHelper.ExecuteSafely<TaskRunnerPropertiesModel, MappingException>(
                        () => _modelBuilder.BuildPropertiesModel(selectedMessage)));
        }

        public JsonResult SendMessage(string typeName, params TaskRunnerPropertyModel[] propertiesForMessage)
        {
            return _safeExecutionHelper.ExecuteSafely<JsonResult, MappingException>(() =>
            {
                var messageType = _modelBuilder.GetMessage(typeName);

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

            _messageBusManager.SendMessage(message);
            _customLogger.Info("Message sent successfully!");
        }
    }
}