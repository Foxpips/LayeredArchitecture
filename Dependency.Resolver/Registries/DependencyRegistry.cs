using Business.Logic.Layer.Interfaces.Startup;

using StructureMap.Configuration.DSL;

namespace Dependency.Resolver.Registries
{
    public class DependencyRegistry : Registry
    {
        public DependencyRegistry()
        {
            Scan(scan =>
            {
                scan.TheCallingAssembly();
                scan.AddAllTypesOf<IDependencyBootStrapper>();
            });
        }
    }
}