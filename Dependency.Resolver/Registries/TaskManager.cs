using System;
using System.Linq;

using Business.Logic.Layer.Interfaces.Startup;

using Dependency.Resolver.Loaders;

namespace Dependency.Resolver.Registries
{
    public class TaskManager
    {
        public static void ExecuteStartupTasks()
        {
            var exportedTypes = typeof (DependencyManager).Assembly.GetExportedTypes();

            foreach (
                var exportedType in
                    exportedTypes.Where(exportedType => (typeof (IRunAtStartup)).IsAssignableFrom(exportedType)))
            {
                ((IRunAtStartup) Activator.CreateInstance(exportedType)).Execute();
            }
        }
    }
}