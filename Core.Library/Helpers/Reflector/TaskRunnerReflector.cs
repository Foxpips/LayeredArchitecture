using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;

using Business.Logic.Layer.Interfaces.Reflection;
using Business.Logic.Layer.Pocos.Reflection;

using Core.Library.Extensions;

using Framework.Layer.Logging;

using Rhino.ServiceBus;
using Rhino.ServiceBus.Impl;

using StructureMap;

namespace Core.Library.Helpers.Reflector
{
    public class TaskRunnerReflector : IReflector
    {
        private readonly CustomLogger _logger = new CustomLogger();

        public TaskRunnerReflector()
        {
            _logger.Log(msg => msg.Info("Configuring the service bus"));
            new OnewayRhinoServiceBusConfiguration()
                .UseStructureMap(ObjectFactory.Container)
                .Configure();
        }

        public IEnumerable<Type> GetTypesFromDll(string assemblyPath)
        {
            var assembly = Assembly.LoadFile(assemblyPath);

            return assembly.GetExportedTypes().Where(x =>
                x.Name.EndsWith("Event", StringComparison.OrdinalIgnoreCase) ||
                x.Name.EndsWith("Command", StringComparison.OrdinalIgnoreCase));
        }

        public void SendMessage(Type messageType, PropertyWithValue[] props = null)
        {
            _logger.Log(msg => msg.Info("Sending message to the bus: " + messageType.Name));

            var instance = Activator.CreateInstance(messageType);
            if (props != null)
            {
                instance.SetPublicProperties(props);
            }

            var bus = ObjectFactory.GetInstance<IOnewayBus>();
            bus.Send(instance);

            _logger.Log(msg => msg.Info("Message sent successfully!"));
        }

        public Type GetMessageType(string typeName)
        {
            return DomainHelper.GetTypeFromAssembly(typeName);
        }
    }
}