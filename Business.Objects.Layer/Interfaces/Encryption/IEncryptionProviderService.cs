namespace Business.Objects.Layer.Interfaces.Encryption
{
    public interface IEncryptionProviderService
    {
        string Encrypt(string plaintext);
        string Decrypt(string ciphertext);
    }
}