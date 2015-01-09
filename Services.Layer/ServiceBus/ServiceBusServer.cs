using System.Reflection;

using Common.Logging;

using Rhino.ServiceBus.Hosting;
using Rhino.ServiceBus.Msmq;

using Service.Layer.ServiceBus.Infrastructure;

namespace Service.Layer.ServiceBus
{
    public class ServiceBusServer
    {
        private static readonly ILog _logger = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
        public static void Start<TBootStrapper>() where TBootStrapper : AbstractBootStrapper
        {
//            new CustomLogger().Log(log => log.Info("Starting the service bus.."));
            _logger.Info("starting bus");
            PrepareQueues.Prepare(BusConfig.GetBusEndpoint(), QueueType.Standard);

            var host = new DefaultHost();
            host.Start<TBootStrapper>();
        }
    }
}