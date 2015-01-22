using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;

using Rhino.ServiceBus;
using Rhino.ServiceBus.Impl;

using StructureMap;

namespace TaskRunner.Dash.Helpers
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

        public void SendMessage(Type messageType, Func<string, string> getPropValue)
        {
            object instance = Activator.CreateInstance(messageType);
            foreach (PropertyInfo propertyInfo in messageType.GetPublicProperties())
            {
                string value = getPropValue(propertyInfo.Name);
                object realObjectType = Convert.ChangeType(value, propertyInfo.PropertyType);

                propertyInfo.SetValue(instance, realObjectType, new object[] {});
            }

            var bus = ObjectFactory.GetInstance<IOnewayBus>();
            bus.Send(instance);
        }
    }
}

namespace TaskRunner.Dash.Helpers
{
    public static class Extensions
    {
        public static PropertyInfo[] GetPublicProperties(this IReflect type)
        {
            return type.GetProperties(BindingFlags.CreateInstance | BindingFlags.Public);
        }
    }
}