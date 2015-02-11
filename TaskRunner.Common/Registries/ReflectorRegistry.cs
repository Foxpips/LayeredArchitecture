﻿using Business.Logic.Layer.Managers.ServiceBus;
using Business.Objects.Layer.Interfaces;
using Business.Objects.Layer.Interfaces.Reflection;

using Core.Library.Helpers.Reflector;

using StructureMap.Configuration.DSL;

namespace TaskRunner.Common.Registries
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