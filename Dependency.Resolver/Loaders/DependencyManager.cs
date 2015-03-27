using Business.Logic.Layer.Interfaces.Startup;

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

        public IContainer ConfigureStartupDependencies()
        {
            Container.Configure(cfg => cfg.AddRegistry(new DependencyRegistry()));

//            using (IContainer container = _container.GetNestedContainer())
//            {
            foreach (IDependencyBootStrapper startUpDependency in Container.GetAllInstances<IDependencyBootStrapper>())
            {
                startUpDependency.ConfigureContainer(Container);
            }
//            }
            return Container;
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