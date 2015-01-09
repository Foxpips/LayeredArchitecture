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
        [Test]
        public void MethodUnderTest_TestedBehavior_ExpectedResult()
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
            Server<TaskRunnerBootStrapper>.Start();
            Thread.Sleep(TimeSpan.FromSeconds(5));
        }
    }
}