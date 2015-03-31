using Dependency.Resolver.BootStrappers;
using Dependency.Resolver.Registries;

using StructureMap;
using StructureMap.Configuration.DSL;

namespace Dependency.Resolver.Loaders
{
    public class DependencyManager
    {
        private readonly IContainer _container;

        public DependencyManager(IContainer container = null)
        {
            _container = container ?? new Container();
        }

        public IContainer Container
        {
            get { return _container; }
        }

        public IContainer ConfigureStartupDependencies(ContainerType containerType = ContainerType.Standard)
        {
            var container = containerType.Equals(ContainerType.Nested) ? _container.GetNestedContainer() : _container;
            container.Configure(cfg => cfg.AddRegistry(new DependencyRegistry()));

            foreach (var startUpDependency in container.GetAllInstances<IDependencyBootStrapper>())
            {
                startUpDependency.ConfigureContainer(container);
            }

            return container;
        }

        public void AddRegistry<TRegistry>() where TRegistry : Registry, new()
        {
            Container.Configure(cfg => cfg.AddRegistry(new TRegistry()));
        }

        public void AddRegistries<TRegistry>(params TRegistry[] registries) where TRegistry : Registry, new()
        {
            foreach (TRegistry registry in registries)
            {
                TRegistry registryToBeAdded = registry;
                Container.Configure(cfg => cfg.AddRegistry(registryToBeAdded));
            }
        }
    }
}