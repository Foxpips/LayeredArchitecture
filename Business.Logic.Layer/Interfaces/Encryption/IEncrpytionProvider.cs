namespace Business.Objects.Layer.Interfaces.Encryption
{
    public interface IEncrpytionProvider
    {
        string Encrypt(string plaintext);
        string Decrypt(string ciphertext);
    }
}