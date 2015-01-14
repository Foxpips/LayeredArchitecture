using System;
using System.Threading;

using NUnit.Framework;

using Rhino.ServiceBus;

using TaskRunner.Common.Messages.Test;
using TaskRunner.Core.BootStrappers;
using TaskRunner.Core.ServiceBus;

namespace IntegrationTests.TaskRunnerTests
{
    public class TaskRunneTest
    {
        [SetUp]
        public void Setup()
        {
//            SendMessageToBus();
        }

        [Test]
        public void Send_ClientMessage_ToServiceBus_Server()
        {
            SendMessageToBus();
        }

        private static void SendMessageToBus()
        {
            using (var client = new Client<IOnewayBus>())
            {
                client.Bus.Send(new HelloWorldCommand
                {
                    Text = "Hello there world!"
                });
            }
        }

        [Test]
        public void Server_TestedBehavior_ExpectedResult()
        {
            var client = new Client<IOnewayBus>();
            client.Bus.Send(new HelloWorldCommand
            {
                Text = "Hello there world!"
            });

            Server<TaskRunnerBootStrapper>.Start();
            Thread.Sleep(TimeSpan.FromSeconds(2));
        }
    }
}