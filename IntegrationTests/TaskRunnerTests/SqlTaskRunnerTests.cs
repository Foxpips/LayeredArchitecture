using NUnit.Framework;
using NUnit.Framework.SyntaxHelpers;

using SqlAgentUIRunner.Controllers;
using SqlAgentUIRunner.Infrastructure.Manager;
using SqlAgentUIRunner.Models.TaskRunnerModels;

using TaskRunner.Core.Reflector;

namespace IntegrationTests.TaskRunnerTests
{
    public class SqlTaskRunnerTests
    {
        public ServiceBusMessageManager Manager { get; set; }
        public MessageBusController Controller { get; set; }

        [SetUp]
        public void SetUp()
        {
            Manager = new ServiceBusMessageManager(new TaskRunnerReflector(),
                @"c:\Users\smarkey\Documents\GitHub\LayeredArchitecture\TaskRunner.Common\bin\Debug\TaskRunner.Common.dll");
            Controller = new MessageBusController(Manager);
        }

        [Test]
        public void Test_MessageBusController_Messages()
        {
            var messagesModel = ((TaskRunnerMessagesModel) Controller.GetMessages().Data).Messages;

            Assert.That(messagesModel.Contains("HelloWorldCommand"), Is.True);
        }

        [Test]
        public void Test_MessageBusController_Properties()
        {
            var messagesModel = ((TaskRunnerPropertiesModel)Controller.GetProperties("HelloWorldCommand").Data).Properties;

            Assert.That(messagesModel.Contains(new TaskRunnerPropertyModel { Id = "Text", Name = "Text" }), Is.True);
        }
    }
}