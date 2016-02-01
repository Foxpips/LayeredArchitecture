using Dependency.Resolver.Interfaces;
using Dependency.Resolver.Registries;

using StructureMap;

namespace Dependency.Resolver.BootStrappers
{
    public class FrameworkDependencyBootStrapper : IDependencyBootStrapper 
    {
        public void ConfigureContainer(IContainer container)
        {
            container.Configure(cfg =>
            {
                cfg.AddRegistry(new LoggerRegistry());
                cfg.AddRegistry(new EncryptionRegistry());
                cfg.AddRegistry(new ReflectorRegistry());
            });
        }
    }
}