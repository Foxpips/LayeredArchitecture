namespace Service.Layer.EncryptionService.Services
{
    public interface IEncryptionProviderService
    {
        string Encrypt(string plaintext);
        string Decrypt(string ciphertext);
    }
}