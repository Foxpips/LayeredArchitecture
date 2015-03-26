using Business.Logic.Layer.Interfaces.Startup;

using Dependency.Resolver.Registries;

using StructureMap;

namespace Dependency.Resolver.BootStrappers
{
    public class FrameworkDependencyBootStrapper : IDependencyBootStrapper
    {
        public IContainer ConfigureContainer()
        {
            ObjectFactory.Container.Configure(x =>
            {
                x.AddRegistry(new LoggerRegistry());
                x.AddRegistry(new EncryptionRegistry());
                x.AddRegistry(new ReflectorRegistry());
            });

            return ObjectFactory.Container;
        }
    }
}