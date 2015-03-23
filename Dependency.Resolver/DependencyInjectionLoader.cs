using System;
using System.Linq;

using Business.Logic.Layer.Interfaces.Startup;

namespace Dependency.Resolver
{
    public class DependencyInjectionLoader
    {
        public static void ConfigureDependencies()
        {
            var exportedTypes = typeof (DependencyInjectionLoader).Assembly.GetExportedTypes();

            foreach (
                var exportedType in
                    exportedTypes.Where(exportedType => (typeof (IRunAtStartup)).IsAssignableFrom(exportedType)))
            {
                ((IRunAtStartup) Activator.CreateInstance(exportedType)).Initialize();
            }
        }
    }
}