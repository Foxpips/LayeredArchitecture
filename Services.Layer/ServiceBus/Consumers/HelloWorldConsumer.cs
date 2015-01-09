using System;

using Framework.Layer.Logging;

using Rhino.ServiceBus;

using TaskRunner.Common.Messages;

namespace Service.Layer.ServiceBus.Consumers
{
    public class HelloWorldConsumer : ConsumerOf<HelloWorldMessage>
    {
        public void Consume(HelloWorldMessage message)
        {
            var logger = new CustomLogger();

            logger.Log(log => log.Info("Consuming hellow world message!"));
            logger.Log(log => log.Info(message.Text));
            Console.WriteLine(message.Text);
        }
    }
}