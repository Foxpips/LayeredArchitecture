using Business.Logic.Layer.Interfaces.Encryption;
using Business.Logic.Layer.Interfaces.Logging;

using Rhino.ServiceBus;

using TaskRunner.Common.Messages.Test;

namespace TaskRunner.Core.Consumers
{
    public class HelloWorldCommandConsumer : ConsumerOf<HelloWorldCommand>
    {
        public ICustomLogger Logger { get; set; }
        private readonly IEncrpytionProvider _encrpytionProvider;

        public HelloWorldCommandConsumer(IEncrpytionProvider encrpytionProvider, ICustomLogger logger)
        {
            Logger = logger;
            _encrpytionProvider = encrpytionProvider;
        }

        public void Consume(HelloWorldCommand message)
        {
            Logger.Info("ConsumingHelloWorldCommand Message!");
            Logger.Info("Encrypted text is: " + message.Text);
            Logger.Info("Decrypred Text is: " + _encrpytionProvider.Decrypt(message.Text));
        }
    }
}