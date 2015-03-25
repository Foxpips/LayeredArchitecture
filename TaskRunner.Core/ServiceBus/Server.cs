using Business.Logic.Layer.Interfaces.Logging;

using Rhino.ServiceBus.Hosting;
using Rhino.ServiceBus.Msmq;

using StructureMap;

using TaskRunner.Core.Infrastructure.Configuration;

namespace TaskRunner.Core.ServiceBus
{
    public class Server
    {
        public static void Start<TBootStrapper>() where TBootStrapper : AbstractBootStrapper
        {
            var logger = ObjectFactory.Container.GetInstance<ICustomLogger>();

            logger.Info("Preparing Queues");
            PrepareQueues.Prepare(BusConfig.GetBusEndpoint(), QueueType.Standard);

            logger.Info("Starting TaskRunner");
            var host = new DefaultHost();
            host.Start<TBootStrapper>();
        }
    }
}