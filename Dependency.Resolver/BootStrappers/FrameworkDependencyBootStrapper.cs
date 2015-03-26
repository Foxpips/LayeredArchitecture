using Business.Logic.Layer.Interfaces.Startup;

using Dependency.Resolver.Registries;

using StructureMap;

namespace Dependency.Resolver.BootStrappers
{
    public class FrameworkDependencyBootStrapper : IDependencyBootStrapper
    {
        private readonly IContainer _container;

        public FrameworkDependencyBootStrapper(IContainer container)
        {
            _container = container;
        }

        public IContainer ConfigureContainer()
        {
            _container.Configure(x =>
            {
                x.AddRegistry(new LoggerRegistry());
                x.AddRegistry(new EncryptionRegistry());
                x.AddRegistry(new ReflectorRegistry());
            });

            return _container;
        }
    }
}