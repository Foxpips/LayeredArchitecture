using Business.Logic.Layer.Interfaces.Startup;

using Dependency.Resolver.Registries;

using StructureMap;

namespace Dependency.Resolver.BootStrappers
{
    public class FrameworkBootStrapper : IStartUpDependency
    {
        public void CreateDependency()
        {
            ObjectFactory.Initialize(x =>
            {
                x.AddRegistry(new LoggerRegistry());
                x.AddRegistry(new EncryptionRegistry());
                x.AddRegistry(new ReflectorRegistry());
            });
        }
    }
}