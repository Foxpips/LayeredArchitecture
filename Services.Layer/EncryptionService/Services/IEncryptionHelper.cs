namespace Service.Layer.EncryptionService.Services
{
    public interface IEncryptionHelper
    {
        string Encrypt(string plaintext);
        string Decrypt(string ciphertext);
    }
}