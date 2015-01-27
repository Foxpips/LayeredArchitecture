using Core.Library.Helpers;

using NUnit.Framework;
using NUnit.Framework.SyntaxHelpers;

using SqlAgentUIRunner.Controllers;
using SqlAgentUIRunner.Infrastructure.Manager;

using TaskRunner.Core.Reflector;

namespace IntegrationTests.ScriptRunnerService
{
    public class SqlTaskRunnerTests
    {
        [Ignore]
        [Test]
        public void Test_MessageBusController_Methods()
        {
            var serviceBusMessageManager = new ServiceBusMessageManager(new TaskRunnerReflector(),
                @"c:\Users\smarkey\Documents\GitHub\LayeredArchitecture\TaskRunner.Common\bin\Debug\TaskRunner.Common.dll");
            var controller = new MessageBusController(serviceBusMessageManager);

            var jsonMessages = controller.GetMessages();

            var serializeJson = JsonHelper.SerializeJson(jsonMessages.Data);

//            JsonHelper.DeserializeJson<TaskRunnerMessagesModel>(jsonMessages.Data);

//            var jsonProperties = controller.GetProperties(messages.FirstOrDefault());

            Assert.That(jsonMessages, Is.Not.Null);
//            Assert.That(jsonProperties, Is.Not.Null);
        }
    }
}