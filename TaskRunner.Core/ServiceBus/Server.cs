using Framework.Layer.Logging;

using Rhino.ServiceBus.Hosting;
using Rhino.ServiceBus.Msmq;

using TaskRunner.Core.Infrastructure.ServiceBus;

namespace TaskRunner.Core.ServiceBus
{
    public class Server<TBootStrapper> where TBootStrapper : AbstractBootStrapper
    {
        public static void Start()
        {
            var logger = new CustomLogger();

            logger.Log(log => log.Info("Starting TaskRunner"));
            PrepareQueues.Prepare(BusConfig.GetBusEndpoint(), QueueType.Standard);

            var host = new DefaultHost();
            host.Start<TBootStrapper>();
        }
    }
}