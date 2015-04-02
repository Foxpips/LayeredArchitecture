using Business.Logic.Layer.Helpers.Reflector;
using Business.Logic.Layer.Managers.ServiceBus;
using Business.Objects.Layer.Interfaces.Reflection;
using Business.Objects.Layer.Interfaces.ServiceBus;

using StructureMap.Configuration.DSL;

namespace Dependency.Resolver.Registries
{
    public class ReflectorRegistry : Registry
    {
        public ReflectorRegistry()
        {
            For<IReflector>().Use<TaskRunnerReflector>();
            For<IServiceBusModelBuilder>().Use<ServiceBusModelBuilder>().Ctor<string>("path")
                .Is(
                    @"C:\Users\smarkey\Documents\GitHub\LayeredArchitecture\SharedDlls\TaskRunner.Common.dll");
        }
    }
}