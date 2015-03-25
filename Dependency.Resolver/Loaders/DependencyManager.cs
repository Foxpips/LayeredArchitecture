using Business.Logic.Layer.Interfaces.Startup;

using Dependency.Resolver.Registries;

using StructureMap;

namespace Dependency.Resolver.Loaders
{
    public class DependencyManager
    {
        public static void ConfigureStartupDependencies()
        {
            ObjectFactory.Container.Configure(cfg => cfg.AddRegistry(new DependencyRegistry()));

            using (IContainer container = ObjectFactory.Container.GetNestedContainer())
            {
                foreach (IStartUpDependency startUpDependency in container.GetAllInstances<IStartUpDependency>())
                {
                    startUpDependency.CreateDependency();
                }
            }
        }
    }
}