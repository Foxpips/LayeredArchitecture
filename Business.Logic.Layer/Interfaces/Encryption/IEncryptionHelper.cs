namespace Business.Objects.Layer.Interfaces.Encryption
{
    public interface IEncryptionHelper
    {
        string Encrypt(string plaintext);
        string Decrypt(string ciphertext);
    }
}