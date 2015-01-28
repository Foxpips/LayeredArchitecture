using System;
using System.Linq;

using NUnit.Framework;
using NUnit.Framework.SyntaxHelpers;

using SqlAgentUIRunner.Controllers;
using SqlAgentUIRunner.Infrastructure.Manager;
using SqlAgentUIRunner.Models.TaskRunnerModels;

using TaskRunner.Common.Messages.Test;
using TaskRunner.Core.Reflector;

namespace IntegrationTests.TaskRunnerTests
{
    public class SqlTaskRunnerTests
    {
        private ServiceBusMessageManager Manager { get; set; }
        private MessageBusController Controller { get; set; }
        private Type MessageType { get; set; }

        [SetUp]
        public void SetUp()
        {
            Manager = new ServiceBusMessageManager(new TaskRunnerReflector(),
                @"c:\Users\smarkey\Documents\GitHub\LayeredArchitecture\TaskRunner.Common\bin\Debug\TaskRunner.Common.dll");
            Controller = new MessageBusController(Manager);
            MessageType = typeof (HelloWorldCommand);
        }

        [Test]
        public void Test_MessageBusController_Messages()
        {
            var messagesModel = ((TaskRunnerMessagesModel) Controller.GetMessages().Data).Messages;

            Assert.That(messagesModel.Contains(MessageType.Name), Is.True);
        }

        [Test]
        public void Test_MessageBusController_Properties()
        {
            var messagesModel = ((TaskRunnerPropertiesModel) Controller.GetProperties(MessageType.Name).Data).Properties;

            var type = MessageType.GetProperties().First().Name;

            Assert.That(messagesModel.First().Name.Equals(type), Is.True);
        }
    }
}