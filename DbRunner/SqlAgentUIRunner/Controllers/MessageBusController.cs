using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Web.Mvc;

using NUnit.Framework;

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
            var reflector = new TaskRunnerReflector();
            var typesFromDll = reflector.GetTypesFromDll(
                PATH);

            var fromDll = typesFromDll as IList<Type> ?? typesFromDll.ToList();
            var message = new TaskRunnerModel(fromDll);

            return View(message);
        }

        [TestCase("TaskRunner.Common.Messages.Test.HelloWorldCommand")]
        public JsonResult GetProperties(string typeName)
        {
            Assembly.LoadFile(
                PATH);

            IEnumerable<Assembly> assemblies =
                AppDomain.CurrentDomain.GetAssemblies().Where(assembly => assembly.FullName.Contains("TaskRunner"));
            Type selectedType = assemblies
                .SelectMany(x => x.GetTypes())
                .FirstOrDefault(x => x.Name == typeName);

            var message = new List<SelectListItem>();
            if (selectedType != null)
            {
                var propertyInfos = selectedType.GetProperties();

                message.AddRange(propertyInfos.Select(publicProperty => new SelectListItem {Text = publicProperty.Name}));
            }

            JsonResult s = Json(message);
            return s;
        }

        public JsonResult SendMessageWithParams(string typeName, PropertyWithValue[] propertiesForMessage)
        {
            Type messageType = GetMessageType(typeName, PATH);
            var reflector = new TaskRunnerReflector();
            reflector.SendMessage(messageType,propertiesForMessage);
            return Json(new { success = true });
        }

        public JsonResult SendMessage(string typeName)
        {
            Type messageType = GetMessageType(typeName, PATH);
            var reflector = new TaskRunnerReflector();
            reflector.SendMessage(messageType);
            return Json(new { success = true });
        }

        private static Type GetMessageType(string typeName, string path)
        {
            Assembly.LoadFile(
                path);

            Type selectedType = AppDomain.CurrentDomain.GetAssemblies()
                .SelectMany(x => x.GetTypes())
                .FirstOrDefault(x => x.Name == typeName);

            return selectedType;
        }
    }
}