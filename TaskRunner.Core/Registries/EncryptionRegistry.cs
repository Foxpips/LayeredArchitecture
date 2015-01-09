using Service.Layer.EncryptionService.Encryption;
using Service.Layer.EncryptionService.Encryption.Asymmetric;

using StructureMap.Configuration.DSL;

namespace TaskRunner.Core.Registries
{
    public class EncryptionRegistry : Registry
    {
        public EncryptionRegistry()
        {
            Scan(scan => For<IEncrpytionProvider>().Use<Rsa>());
        }
    }
}