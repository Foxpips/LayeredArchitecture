using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;

using Rhino.ServiceBus;
using Rhino.ServiceBus.Impl;

using StructureMap;

namespace TaskRunner.Core.Reflector
{
    public class TaskRunnerReflector
    {
        public TaskRunnerReflector()
        {
            new OnewayRhinoServiceBusConfiguration()
                .UseStructureMap(ObjectFactory.Container)
                .Configure();
        }

        public IEnumerable<Type> GetTypesFromDll(string assemblyPath)
        {
            Assembly assembly = Assembly.LoadFile(assemblyPath);

            return assembly.GetExportedTypes().Where(x =>
                x.Name.EndsWith("Event", StringComparison.OrdinalIgnoreCase) ||
                x.Name.EndsWith("Command", StringComparison.OrdinalIgnoreCase));
        }

        public void SendMessage(Type messageType, PropertyWithValue[] props = null)
        {
            object instance = Activator.CreateInstance(messageType);
            if (props != null)
            {
                PropertyInfo[] propertyInfos = messageType.GetProperties();
                foreach (PropertyInfo propertyInfo in propertyInfos)
                {
                    foreach (PropertyWithValue prop in props)
                    {
                        if (propertyInfo.Name.Equals(prop.Name))
                        {
                            propertyInfo.SetValue(instance, prop.Value);
                        }
                    }
                }
            }

            var bus = ObjectFactory.GetInstance<IOnewayBus>();

            bus.Send(instance);
        }

        public Type GetMessageType(string typeName, string path)
        {
            Assembly.LoadFile(
                path);

            var selectedType = AppDomain.CurrentDomain.GetAssemblies()
                .SelectMany(x => x.GetTypes())
                .FirstOrDefault(x => x.Name == typeName);

            return selectedType;
        }
    }
}