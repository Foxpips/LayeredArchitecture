using Business.Logic.Layer.Interfaces.Startup;

using Dependency.Resolver.Registries;

using StructureMap;
using StructureMap.Configuration.DSL;

namespace Dependency.Resolver.Loaders
{
    public class DependencyManager
    {
        public static void ConfigureStartupDependencies()
        {
            ObjectFactory.Container.Configure(cfg => cfg.AddRegistry(new DependencyRegistry()));

            using (IContainer container = ObjectFactory.Container.GetNestedContainer())
            {
                foreach (IDependencyBootStrapper startUpDependency in container.GetAllInstances<IDependencyBootStrapper>())
                {
                    startUpDependency.ConfigureContainer();
                }
            }
        }

        public static void AddRegistry<TRegistry>() where TRegistry : Registry, new()
        {
            ObjectFactory.Container.Configure(cfg => cfg.AddRegistry(new TRegistry()));
        }

        public static void AddRegistries<TRegistry>(params TRegistry[] registries) where TRegistry : Registry, new()
        {
            foreach (TRegistry registry in registries)
            {
                TRegistry registryToBeAdded = registry;
                ObjectFactory.Container.Configure(cfg => cfg.AddRegistry(registryToBeAdded));
            }
        }
    }
}