using System;
using System.Linq;

using Business.Logic.Layer.Helpers.Reflector;
using Business.Logic.Layer.Managers.ServiceBus;
using Business.Objects.Layer.Interfaces.Logging;
using Business.Objects.Layer.Models.TaskRunner;

using Dependency.Resolver.Loaders;

using NUnit.Framework;
using NUnit.Framework.SyntaxHelpers;

using Rhino.ServiceBus;

using SqlAgentUIRunner.Controllers;

using TaskRunner.Common.Messages.Test;
using TaskRunner.Core.ServiceBus;

namespace Tests.Integration.TaskRunnerTests
{
    public class SqlTaskRunnerTests
    {
        private ServiceBusMessageManager Manager { get; set; }
        private MessageBusController Controller { get; set; }
        private Type MessageType { get; set; }

        [SetUp]
        public void SetUp()
        {
            var container = new DependencyManager().ConfigureStartupDependencies();

            MessageType = typeof (HelloWorldCommand);

            Manager = new ServiceBusMessageManager(new TaskRunnerReflector(),
                @"c:\Users\smarkey\Documents\GitHub\LayeredArchitecture\TaskRunner.Common\bin\Debug\TaskRunner.Common.dll");

            Controller = new MessageBusController(Manager, container.GetInstance<ICustomLogger>(),
                new Client<IOnewayBus>(container));
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