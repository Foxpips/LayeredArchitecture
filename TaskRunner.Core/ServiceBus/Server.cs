using Business.Logic.Layer.Interfaces.Logging;

using Rhino.ServiceBus.Hosting;
using Rhino.ServiceBus.Msmq;

using StructureMap;

using TaskRunner.Core.Infrastructure.Configuration;

namespace TaskRunner.Core.ServiceBus
{
    public class Server<TBootStrapper> where TBootStrapper : AbstractBootStrapper
    {
        public static void Start()
        {
//            var logger = new CustomLogger();

            var instance = ObjectFactory.Container.GetInstance<ICustomLogger>();

            instance.Info("Starting TaskRunner");
            //            logger.Log(log => log.Info("Starting TaskRunner"));
            PrepareQueues.Prepare(BusConfig.GetBusEndpoint(), QueueType.Standard);

            var host = new DefaultHost();
            host.Start<TBootStrapper>();
        }
    }
}