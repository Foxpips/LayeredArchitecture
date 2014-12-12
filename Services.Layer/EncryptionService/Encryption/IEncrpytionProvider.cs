namespace Service.Layer.EncryptionService.Encryption
{
    public interface IEncrpytionProvider
    {
        string Encrypt(string plaintext);
        string Decrypt(string ciphertext);
    }
}