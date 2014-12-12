using System;
using System.Security.Cryptography;
using System.Text;

namespace Service.Layer.EncryptionService.Encryption.Symmetric
{
    public class TripleDes : SymmetricEncryptionProviderBase
    {
        public TripleDes() : base("adfhdsiajnlfo4389525j329", "dftyffei")
        {
        }

        public override string Decrypt(string ciphertext)
        {
            var cryptoTransform = new TripleDESCryptoServiceProvider().CreateDecryptor(_key, _iv);
            var fromBase64String = Convert.FromBase64String(ciphertext);
            var executeCryptoServiceProvider = ExecuteCryptoServiceProvider(fromBase64String, cryptoTransform);
            return Encoding.ASCII.GetString(executeCryptoServiceProvider);
        }

        public override string Encrypt(string plaintext)
        {
            var cryptoTransform = new TripleDESCryptoServiceProvider().CreateEncryptor(_key, _iv);
            var bytes = Encoding.ASCII.GetBytes(plaintext);
            var executeCryptoServiceProvider = ExecuteCryptoServiceProvider(bytes, cryptoTransform);
            return Convert.ToBase64String(executeCryptoServiceProvider);
        }
    }
}