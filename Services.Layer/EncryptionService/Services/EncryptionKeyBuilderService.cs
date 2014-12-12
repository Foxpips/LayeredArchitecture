using Service.Layer.EncryptionService.KeyCreation.Keys;

namespace Service.Layer.EncryptionService.Services
{
    public class EncryptionKeyBuilderService<TKey> where TKey : IKey, new()
    {
        public static void GenerateKeys()
        {
            new TKey().CreateKeys();
        }
    }
}