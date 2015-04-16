using System;
using System.Reflection;
using System.Threading;

using Business.Objects.Layer.Interfaces.Startup;

using Dependency.Resolver.Registries;

using NUnit.Framework;

using Rhino.ServiceBus;
using Rhino.ServiceBus.Impl;

using StructureMap;

using TaskScheduler.Quartz.Registries;

namespace Tests.Integration.TaskScheduler.Tests
{
    public class TaskSchedulerTests
    {
        [Test]
        public void MethodUnderTest_TestedBehavior_ExpectedResult()
        {
            var container = new Container();
            container.Configure(cfg =>
            {
                cfg.AddRegistry(new QuartzRegistry(container));
                cfg.AddRegistry(new LoggerRegistry());
                cfg.Scan(scan =>
                {
                    scan.Assembly(Assembly.GetAssembly(typeof (QuartzRegistry)));
                    scan.AddAllTypesOf<IRunAtStartup>();
                });
            });

            new OnewayRhinoServiceBusConfiguration()
                .UseStructureMap(container)
                .Configure();

            using (IContainer nestedContainer = container.GetNestedContainer())
            {
                foreach (IRunAtStartup task in nestedContainer.GetAllInstances<IRunAtStartup>())
                {
                    task.Execute();
                }
            }

            Thread.Sleep(TimeSpan.FromSeconds(15));
        }

        private static void ContainerContents(Container container)
        {
            var whatDoIHave = container.WhatDoIHave();
            Console.WriteLine(whatDoIHave);
        }
    }
}