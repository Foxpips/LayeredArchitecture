using System;

using Framework.Layer.Logging;

using Rhino.ServiceBus;

using Service.Layer.EncryptionService.Encryption;

using TaskRunner.Common.Messages.Test;

namespace TaskRunner.Core.Consumers
{
    public class HelloWorldCommandConsumer : ConsumerOf<HelloWorldCommand>
    {
        private readonly IEncrpytionProvider _encrpytionProvider;

        public HelloWorldCommandConsumer(IEncrpytionProvider encrpytionProvider)
        {
            _encrpytionProvider = encrpytionProvider;
        }

        public void Consume(HelloWorldCommand message)
        {
            var logger = new CustomLogger();
            logger.Log(log =>
            {
                log.Info("ConsumingHelloWorldCommand Message!");
                log.Info("Encrypred Text is: " + _encrpytionProvider.Encrypt(message.Text));
            });

            Console.WriteLine(message.Text);
        }
    }
}