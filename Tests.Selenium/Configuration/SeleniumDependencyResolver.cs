using Dependency.Resolver.Loaders;
using StructureMap;
using Tests.Selenium.Configuration.Registries;

namespace Tests.Selenium.Configuration
{
    public sealed class SeleniumDependencyResolver
    {
        private readonly DependencyManager _dependencyManager;

        public IContainer Container
        {
            get { return _dependencyManager.Container; }    
        }

        public SeleniumDependencyResolver()
        {
            _dependencyManager = new DependencyManager();
//            _dependencyManager.ConfigureStartupDependencies();
            _dependencyManager.AddRegistry<SeleniumRegistry>();
        }
    }
}