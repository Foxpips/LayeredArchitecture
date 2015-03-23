using Service.Layer.EncryptionService.Encryption;

namespace Service.Layer.EncryptionService.Services
{
    public interface IEncryptionProviderService
    {
        string Encrypt(string plaintext);
        string Decrypt(string ciphertext);
    }

    public class EncryptionProviderService<TEncrpyptionProvider> : IEncryptionProviderService where TEncrpyptionProvider : IEncrpytionProvider, new()
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