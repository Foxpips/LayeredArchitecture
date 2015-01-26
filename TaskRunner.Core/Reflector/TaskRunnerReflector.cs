using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;

using NUnit.Framework;

using Rhino.ServiceBus;
using Rhino.ServiceBus.Impl;

using StructureMap;

using TaskRunner.Common.Messages.Test;

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

        [Test]
        public void MethodUnderTest_TestedBehavior_ExpectedResult()
        {
            Assembly assembly =
                Assembly.LoadFile(
                    @"c:\Users\smarkey\Documents\GitHub\LayeredArchitecture\TaskRunner.Common\bin\Debug\TaskRunner.Common.dll");
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

        public void SendMessage(Type messageType)
        {
            object instance = Activator.CreateInstance(messageType);
            var bus = ObjectFactory.GetInstance<IOnewayBus>();
            bus.Send(instance);
        }

        public void SendMessage(Type messageType, PropertyWithValue[] props)
        {
            object instance = Activator.CreateInstance(messageType);

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

            var bus = ObjectFactory.GetInstance<IOnewayBus>();

            bus.Send(instance);
        }
    }

    public class PropertyWithValue
    {
        public string Name { get; set; }
        public string Value { get; set; }
    }

    public static class Extensions
    {
        public static PropertyInfo[] GetPublicProperties(this IReflect type)
        {
            return type.GetProperties(BindingFlags.CreateInstance | BindingFlags.Public);
        }
    }
}