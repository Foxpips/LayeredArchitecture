using Dependency.Resolver.Registries;

using StructureMap;

namespace Dependency.Resolver.BootStrappers
{
    public class FrameworkDependencyBootStrapper : BootStrapperBase
    {
        public override void ConfigureContainer(IContainer container)
        {
            container.Configure(x =>
            {
                x.AddRegistry(new LoggerRegistry());
                x.AddRegistry(new EncryptionRegistry());
                x.AddRegistry(new ReflectorRegistry());
            });
        }
    }
}