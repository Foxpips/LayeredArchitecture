using StructureMap;

namespace Dependency.Resolver.Interfaces
{
    public interface IDependencyBootStrapper
    {
        void ConfigureContainer(IContainer container);
    }
}