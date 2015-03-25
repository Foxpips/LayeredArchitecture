using StructureMap;
using StructureMap.Configuration.DSL;

namespace Dependency.Resolver.Containers
{
    public class CustomContainer
    {
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