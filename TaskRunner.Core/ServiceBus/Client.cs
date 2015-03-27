using System;

using Rhino.ServiceBus;
using Rhino.ServiceBus.Impl;

using StructureMap;

namespace TaskRunner.Core.ServiceBus
{
    public class Client<TBusType> : IDisposable
    {
        private readonly IContainer _container;
        public TBusType Bus { get; set; }

        public Client(IContainer container)
        {
            _container = container;
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
            _container.Dispose();
        }
    }
}