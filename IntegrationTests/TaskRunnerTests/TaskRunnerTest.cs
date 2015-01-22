using System;
using System.Threading;

using NUnit.Framework;

using Rhino.ServiceBus;

using TaskRunner.Common.Messages.Test;
using TaskRunner.Core.BootStrappers;
using TaskRunner.Core.ServiceBus;
using TaskRunner.Dash.Helpers;

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
    }
}