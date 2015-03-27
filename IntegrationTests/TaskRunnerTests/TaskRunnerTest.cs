using System;
using System.Threading;

using Business.Logic.Layer.Interfaces.Logging;

using Core.Library.Helpers.Reflector;

using Dependency.Resolver.Loaders;
using Dependency.Resolver.Registries;

using log4net.Repository.Hierarchy;

using NUnit.Framework;

using Rhino.ServiceBus;
using Rhino.ServiceBus.Hosting;

using Service.Layer.EncryptionService.Services;

using StructureMap;

using TaskRunner.Common.Messages.Test;
using TaskRunner.Core.BootStrappers;
using TaskRunner.Core.Infrastructure.Modules;
using TaskRunner.Core.ServiceBus;

namespace Tests.Integration.TaskRunnerTests
{
    public class TaskRunnerTest
    {
        private IEncryptionProviderService _encryptionProviderService;
        private IContainer _container;

        [SetUp]
        public void Setup()
        {
            _container = new DependencyManager().ConfigureStartupDependencies();
            _encryptionProviderService = _container.GetInstance<IEncryptionProviderService>();
        }

        [Test]
        public void TaskRunner_SendReceive_Message_Tests()
        {
            var client = new Client<IOnewayBus>(_container);
            client.Bus.Send(new HelloWorldCommand
            {
                Text = _encryptionProviderService.Encrypt("Hello there world!")
            });

            Server.Start<TaskRunnerBootStrapper>(_container);
            Thread.Sleep(TimeSpan.FromSeconds(2));
        }

        [Test]
        public void SendMessage_Only_MessageConsumed()
        {
            var client = new Client<IOnewayBus>(_container);
            client.Bus.Send(new HelloWorldCommand {Text = _encryptionProviderService.Encrypt("Hello")});

            Server.Start<CustomBootStrapper<EncryptionRegistry, ServiceBusRegistry,LoggerRegistry>>(_container);
            Thread.Sleep(TimeSpan.FromSeconds(2));
        }

        [Test]
        public void TaskRunnerReflector_Tests()
        {
            var reflector = new TaskRunnerReflector(_container);

            var typesFromDll =
                reflector.GetTypesFromDll(
                    @"C:\Users\smarkey\Documents\GitHub\LayeredArchitecture\IntegrationTests\TestDlls\TaskRunner.Common.dll");

            foreach (var type in typesFromDll)
            {
                Console.WriteLine(type.Name);
            }
        }

        [Test]
        public void ConsumeAllMessagesOnQueue_Consume_MessageQueue()
        {
            var host = new DefaultHost();
            host.Start<CustomBootStrapper<EncryptionRegistry, ServiceBusRegistry>>();
            Thread.Sleep(TimeSpan.FromSeconds(2));
        }

        [Test]
        public void Log4Logger_Injection_Test()
        {
            var container = new Container(scan => scan.AddRegistry<LoggerRegistry>());
            Console.WriteLine(container.WhatDoIHave());
            var messageLogger = container.GetNestedContainer().GetInstance<ICustomLogger>();

            messageLogger.Info("Hey");
        }
    }
}