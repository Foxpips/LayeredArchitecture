using StructureMap;

namespace Dependency.Resolver.BootStrappers
{
    public abstract class BootStrapperBase : IDependencyBootStrapper
    {
        public abstract void ConfigureContainer(IContainer container);
    }
}