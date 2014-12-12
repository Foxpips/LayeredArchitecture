using Service.Layer.EncryptionService.Encryption;

namespace Service.Layer.EncryptionService.Services
{
    public class EncryptionProviderService<TEncrpyptionProvider>
        where TEncrpyptionProvider : IEncrpytionProvider, new()
    {
        private readonly TEncrpyptionProvider _encrpyptionProvider;

        public EncryptionProviderService()
        {
            _encrpyptionProvider = new TEncrpyptionProvider();
        }

        public string Encrypt(string plaintext)
        {
            return _encrpyptionProvider.Encrypt(plaintext);
        }

        public string Decrypt(string ciphertext)
        {
            return _encrpyptionProvider.Decrypt(ciphertext);
        }
    }
}