﻿using System;
using System.IO;
using System.Threading;

using Business.Logic.Layer.Helpers.Reflector;
using Business.Objects.Layer.Interfaces.Encryption;
using Business.Objects.Layer.Interfaces.Logging;

using Dependency.Resolver.Loaders;
using Dependency.Resolver.Registries;

using Framework.Layer.Logging.LogTypes;

using NUnit.Framework;

using Rhino.ServiceBus;
using Rhino.ServiceBus.Hosting;

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

            Server.Start<CustomBootStrapper<EncryptionRegistry, ServiceBusRegistry, LoggerRegistry>>(_container);
            Thread.Sleep(TimeSpan.FromSeconds(4));
        }

        [Test]
        public void TaskRunnerReflector_Tests()
        {
            var reflector = _container.GetInstance<TaskRunnerReflector>();
            var assemblyPath = Directory.GetCurrentDirectory() + @"\TaskRunner.Common.dll";

            var typesFromDll =
                reflector.GetTypesFromDll(
                    assemblyPath);

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
            Console.WriteLine(_container.WhatDoIHave());

            _container.Configure(cfg => cfg.For<ICustomLogger>().Use<ConsoleLogger>());
            var nestedContainer = _container.GetNestedContainer();

            Console.WriteLine(nestedContainer.WhatDoIHave());

            var messageLogger = nestedContainer.GetInstance<ICustomLogger>();
            messageLogger.Info("Hey");
            nestedContainer.Dispose();
        }

        [Test]
        public void IoCContainerTests_Nested_Vs_Standard()
        {
            using (var container = new DependencyManager().ConfigureStartupDependencies(ContainerType.Nested))
            {
                var customLogger = container.GetInstance<ICustomLogger>();

                customLogger.Info("Atomically created logger as Container is a nested Container!");
            }
        }
    }
}