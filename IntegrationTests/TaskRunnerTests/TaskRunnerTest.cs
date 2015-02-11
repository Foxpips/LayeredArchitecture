using System;
using System.Threading;

using Business.Objects.Layer.Interfaces.Logging;

using Core.Library.Helpers.Reflector;

using Framework.Layer.Logging;

using NUnit.Framework;

using Rhino.ServiceBus;

using Service.Layer.EncryptionService.Encryption.Asymmetric;
using Service.Layer.EncryptionService.Services;

using StructureMap;
using StructureMap.Configuration.DSL;

using TaskRunner.Common.Messages.Test;
using TaskRunner.Common.Registries;
using TaskRunner.Core.BootStrappers;
using TaskRunner.Core.Infrastructure.Modules;
using TaskRunner.Core.ServiceBus;

namespace IntegrationTests.TaskRunnerTests
{
    public class TaskRunnerTest
    {
        [Test]
        public void TaskRunner_SendReceive_Message_Tests()
        {
            var client = new Client<IOnewayBus>();
            client.Bus.Send(new HelloWorldCommand
            {
                Text = "Hello there world!"
            });

            Server<TaskRunnerBootStrapper>.Start();
            Thread.Sleep(TimeSpan.FromSeconds(2));
        }

        [Test]
        public void SendMessage_Only_MessageConsumed()
        {
            var client = new Client<IOnewayBus>();
            client.Bus.Send(new HelloWorldCommand {Text = new EncryptionProviderService<Rsa>().Encrypt("Hello")});

            Server<CustomBootStrapper<EncryptionRegistry, ServiceBusRegistry>>.Start();
            Thread.Sleep(TimeSpan.FromSeconds(2));
        }

        [Test]
        public void TaskRunnerReflector_Tests()
        {
            var reflector = new TaskRunnerReflector();

            var typesFromDll =
                reflector.GetTypesFromDll(
                    @"C:\Users\smarkey\Documents\GitHub\LayeredArchitecture\IntegrationTests\TestDlls\TaskRunner.Common.dll");

            foreach (var type in typesFromDll)
            {
                Console.WriteLine(type.Name);
            }
        }

        [Test]
        public void Log4Logger_Injection_Test()
        {
            var container = new Container(scan => scan.AddRegistry<LoggerMessageRegistry>());
            Console.WriteLine(container.WhatDoIHave());
            var messageLogger = container.GetNestedContainer().GetInstance<IMessageLogger>();

            messageLogger.Info("Hey");
        }

        public class LoggerMessageRegistry : Registry
        {
            public LoggerMessageRegistry()
            {
                Scan(scan => For<IMessageLogger>().Transient().Use(scope => new Log4NetFileLogger()));
            }
        }
    }
}