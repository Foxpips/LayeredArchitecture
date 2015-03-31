using Business.Objects.Layer.Interfaces.Startup;

using StructureMap.Configuration.DSL;

namespace Dependency.Resolver.Registries
{
    public class TaskRegistry : Registry
    {
        public TaskRegistry()
        {
            Scan(scan =>
            {
                scan.TheCallingAssembly();
                scan.AddAllTypesOf<IRunAtStartup>();
                scan.AddAllTypesOf<IRunAtShutdown>();
            });
        }
    }
}