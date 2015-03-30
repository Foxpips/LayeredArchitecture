using Business.Logic.Layer.Interfaces.Encryption;

using Service.Layer.EncryptionService.Encryption.Asymmetric;
using Service.Layer.EncryptionService.Services;

using StructureMap.Configuration.DSL;

namespace Dependency.Resolver.Registries
{
    public class EncryptionRegistry : Registry
    {
        public EncryptionRegistry()
        {
            Scan(scan =>
            {
                For<IEncrpytionProvider>().Use<Rsa>();
                For<IEncryptionProviderService>().Use<EncryptionProviderService<Rsa>>();
            });
        }
    }
}