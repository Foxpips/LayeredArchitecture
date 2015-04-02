using System;

using Rhino.ServiceBus;
using Rhino.ServiceBus.Impl;

using StructureMap;

namespace TaskRunner.Core.ServiceBus
{
    public class Client<TBusType> : IDisposable
    {
        public TBusType Bus { get; set; }

        public Client(IContainer container)
        {
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