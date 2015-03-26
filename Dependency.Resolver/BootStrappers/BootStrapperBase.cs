using Business.Logic.Layer.Interfaces.Startup;

using StructureMap;

namespace Dependency.Resolver.BootStrappers
{
    public abstract class BootStrapperBase : IDependencyBootStrapper
    {
        public IContainer Container { get; set; }

        protected BootStrapperBase(IContainer container)
        {
            Container = container;
        }

        public abstract IContainer ConfigureContainer();
    }
}