using System;
using System.Security.Cryptography;
using System.Text;

namespace Service.Layer.EncryptionService.Encryption.Symmetric
{
    public class Aes : SymmetricEncryptionProviderBase
    {
        public Aes() : base("adfhdsiajnlfo4389525j329", "I%d*2K5G91Vb+~#|")
        {
        }

        public override string Encrypt(string plaintext)
        {
            var aesCryptoServiceProvider = new AesCryptoServiceProvider();
            var cryptoTransform = aesCryptoServiceProvider.CreateEncryptor(_key, _iv);
            var bytes = Encoding.ASCII.GetBytes(plaintext);
            var executeCryptoServiceProvider = ExecuteCryptoServiceProvider(bytes, cryptoTransform);
            return Convert.ToBase64String(executeCryptoServiceProvider);
        }

        public override string Decrypt(string ciphertext)
        {
            var aesCryptoServiceProvider = new AesCryptoServiceProvider();
            var cryptoTransform = aesCryptoServiceProvider.CreateDecryptor(_key, _iv);
            var fromBase64String = Convert.FromBase64String(ciphertext);
            var executeCryptoServiceProvider = ExecuteCryptoServiceProvider(fromBase64String, cryptoTransform);
            return Encoding.ASCII.GetString(executeCryptoServiceProvider);
        }
    }
}