using Business.Logic.Layer.Interfaces.Startup;

using Dependency.Resolver.Registries;

using StructureMap;
using StructureMap.Configuration.DSL;

namespace Dependency.Resolver.IOC
{
    public class CustomContainer : IRunAtStartup
    {
        public void Initialize()
        {
            ObjectFactory.Initialize(x =>
            {
                x.AddRegistry(new LoggerRegistry());
                x.AddRegistry(new EncryptionRegistry());
                x.AddRegistry(new ReflectorRegistry());
            });
        }

        public void AddRegistry<TRegistry>() where TRegistry : Registry, new()
        {
            ObjectFactory.Container.Configure(x => x.AddRegistry(new TRegistry()));
        }
    }
}