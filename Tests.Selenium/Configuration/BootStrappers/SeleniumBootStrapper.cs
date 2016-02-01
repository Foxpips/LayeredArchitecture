using Dependency.Resolver.Interfaces;
using StructureMap;
using Tests.Selenium.Configuration.Registries;

namespace Tests.Selenium.Configuration.BootStrappers
{
    public sealed class SeleniumBootStrapper : IDependencyBootStrapper
    {
        public void ConfigureContainer(IContainer container)
        {
            container.Configure(cfg => cfg.AddRegistry<SeleniumRegistry>());
        }
    }
}