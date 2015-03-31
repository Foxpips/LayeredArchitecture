using StructureMap;

namespace Dependency.Resolver.BootStrappers
{
    public interface IDependencyBootStrapper
    {
        void ConfigureContainer(IContainer container);
    }
}