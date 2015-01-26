using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Web.Mvc;

using SqlAgentUIRunner.Models;

using TaskRunner.Core.Reflector;

namespace SqlAgentUIRunner.Controllers
{
    public class MessageBusController : Controller
    {
        public const string PATH =
            @"c:\Users\smarkey\Documents\GitHub\LayeredArchitecture\TaskRunner.Common\bin\Debug\TaskRunner.Common.dll";

        public ActionResult Index()
        {
//            return View(message);
            return View();
        }

        public JsonResult GetMessages()
        {
            var reflector = new TaskRunnerReflector();
            var typesFromDll = reflector.GetTypesFromDll(
                PATH);

            var fromDll = typesFromDll as IList<Type> ?? typesFromDll.ToList();
            var message = new TaskRunnerModel(fromDll);

            return Json(message);
        }

        public JsonResult GetProperties(string selectedMessage)
        {
            Assembly.LoadFile(PATH);

            IEnumerable<Assembly> assemblies =
                AppDomain.CurrentDomain.GetAssemblies().Where(assembly => assembly.FullName.Contains("TaskRunner"));
            Type selectedType = assemblies
                .SelectMany(x => x.GetTypes())
                .FirstOrDefault(x => x.Name == selectedMessage);

            var message = new TaskRunnerPropertiesModel();
            if (selectedType != null)
            {
                var propertyInfos = selectedType.GetProperties();

                message.Properties.AddRange(
                    propertyInfos.Select(property => new CustomTypeProperty {Name = property.Name,  Id = property.Name}));
            }

            return Json(message);
        }

        public JsonResult SendMessage(string typeName, PropertyWithValue[] propertiesForMessage)
        {
            var reflector = new TaskRunnerReflector();
            var messageType = reflector.GetMessageType(typeName, PATH);

            if (!propertiesForMessage.Any())
            {
                reflector.SendMessage(messageType, propertiesForMessage);
            }
            else
            {
                reflector.SendMessage(messageType);
            }

            return Json(new {success = true});
        }
    }

    public class CustomTypeProperty
    {
        public string Name { get; set; }
        public string Id { get; set; }
    }
}