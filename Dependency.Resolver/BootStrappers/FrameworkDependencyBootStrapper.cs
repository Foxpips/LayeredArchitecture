using Dependency.Resolver.Registries;

using StructureMap;

namespace Dependency.Resolver.BootStrappers
{
    public class FrameworkDependencyBootStrapper : BootStrapperBase
    {
        public FrameworkDependencyBootStrapper(IContainer container)
            : base(container)
        {
        }

        public override IContainer ConfigureContainer()
        {
            Container.Configure(x =>
            {
                x.AddRegistry(new LoggerRegistry());
                x.AddRegistry(new EncryptionRegistry());
                x.AddRegistry(new ReflectorRegistry());
            });

            return Container;
        }
    }
}