using System;

using Rhino.ServiceBus;
using Rhino.ServiceBus.Impl;
using Rhino.ServiceBus.Msmq;
using StructureMap;
using TaskRunner.Core.Infrastructure.Configuration;

namespace TaskRunner.Core.ServiceBus
{
    public class Client<TBusType> : IDisposable
    {
        public TBusType Bus { get; set; }

        public Client(IContainer container)
        {
            PrepareQueues.Prepare(BusConfig.GetBusEndpoint(), QueueType.Standard);

            if (Bus == null)
            {
                new OnewayRhinoServiceBusConfiguration()
                    .UseStructureMap(container)
                    .Configure();

                Bus = container.GetInstance<TBusType>();
            }
        }

        public void Dispose()
        {
//            _container.Dispose();
        }
    }
}