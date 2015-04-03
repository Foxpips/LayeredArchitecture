using System;
using System.Reflection;

using Common.Logging;

using Rhino.ServiceBus;

using TaskRunner.Common.Messages;

namespace BackupService.Common.Consumers
{
    public class HelloWorldConsumer : ConsumerOf<HelloWorldMessage>
    {
        private static readonly ILog _logger = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        public void Consume(HelloWorldMessage message)
        {
            _logger.Info("Consuming hellow world message!");
            _logger.Info(message.Text);
            Console.WriteLine(message.Text);
        }
    }
}