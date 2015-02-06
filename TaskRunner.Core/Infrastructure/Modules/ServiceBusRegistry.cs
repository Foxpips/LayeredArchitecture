using Rhino.ServiceBus.MessageModules;

using StructureMap.Configuration.DSL;

namespace TaskRunner.Core.Infrastructure.Modules
{
    public class ServiceBusRegistry : Registry
    {
        public ServiceBusRegistry()
        {
            Scan(scan => For<IMessageModule>().Use<TrackFailedMessagesModule>());
        }
    }
}