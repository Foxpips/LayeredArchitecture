using Business.Logic.Layer.Interfaces.Reflection;
using Business.Logic.Layer.Interfaces.ServiceBus;

using Core.Library.Helpers.Reflector;
using Core.Library.Managers.ServiceBus;

using StructureMap.Configuration.DSL;

namespace Dependency.Resolver.Registries
{
    public class ReflectorRegistry : Registry
    {
        public ReflectorRegistry()
        {
            For<IReflector>().Use<TaskRunnerReflector>();
            For<IServiceBusMessageManager>().Use<ServiceBusMessageManager>().Ctor<string>("path")
                .Is(
                    @"c:\Users\smarkey\Documents\GitHub\LayeredArchitecture\TaskRunner.Common\bin\Debug\TaskRunner.Common.dll");
        }
    }
}