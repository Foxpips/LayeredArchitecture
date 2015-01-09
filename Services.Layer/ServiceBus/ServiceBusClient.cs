using System;

using Rhino.ServiceBus;
using Rhino.ServiceBus.Impl;

using StructureMap;

namespace Service.Layer.ServiceBus
{
    public class ServiceBusClient<TBusType> : IDisposable
    {
        public TBusType Bus { get; set; }

        public ServiceBusClient()
        {
            new OnewayRhinoServiceBusConfiguration()
                .UseStructureMap(ObjectFactory.Container)
                .Configure();

            Bus = ObjectFactory.GetInstance<TBusType>();
        }

        public void Dispose()
        {
            ObjectFactory.Container.Dispose();
        }
    }
}