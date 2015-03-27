using System;
using System.Linq;

using Business.Logic.Layer.Interfaces.Logging;
using Business.Logic.Layer.Models.TaskRunner;

using Core.Library.Helpers.Reflector;
using Core.Library.Managers.ServiceBus;

using Dependency.Resolver.Loaders;

using NUnit.Framework;
using NUnit.Framework.SyntaxHelpers;

using SqlAgentUIRunner.Controllers;

using TaskRunner.Common.Messages.Test;

namespace Tests.Integration.TaskRunnerTests
{
    public class SqlTaskRunnerTests
    {
        private ICustomLogger _customLogger;
        private ServiceBusMessageManager Manager { get; set; }
        private MessageBusController Controller { get; set; }
        private Type MessageType { get; set; }

        [SetUp]
        public void SetUp()
        {
            var container = new DependencyManager().ConfigureStartupDependencies();
            _customLogger = container.GetInstance<ICustomLogger>();
            Manager = new ServiceBusMessageManager(new TaskRunnerReflector(container),
                @"c:\Users\smarkey\Documents\GitHub\LayeredArchitecture\TaskRunner.Common\bin\Debug\TaskRunner.Common.dll");
            Controller = new MessageBusController(Manager, container);
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
            var messageModelProperties =
                ((TaskRunnerPropertiesModel) Controller.GetProperties(MessageType.Name).Data).Properties;

            var typeName = MessageType.GetProperties().First().Name;

            Assert.That(messageModelProperties.Any(x => x.Name.Equals(typeName)));
        }
    }
}