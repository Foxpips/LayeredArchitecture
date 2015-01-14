using System;

using Rhino.ServiceBus;
using Rhino.ServiceBus.Impl;

using StructureMap;

namespace TaskRunner.Core.ServiceBus
{
    public class Client<TBusType> : IDisposable
    {
        public TBusType Bus { get; set; }

        public Client()
        {
            if (Bus == null)
            {
                new OnewayRhinoServiceBusConfiguration()
                    .UseStructureMap(ObjectFactory.Container)
                    .Configure();

                Bus = ObjectFactory.GetInstance<TBusType>();
            }
        }

        public void Dispose()
        {
            ObjectFactory.Container.Dispose();
        }
    }
}