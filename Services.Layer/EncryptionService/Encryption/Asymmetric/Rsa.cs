using System;
using System.Configuration;
using System.IO;
using System.Security.Cryptography;
using System.Text;

using Business.Logic.Layer.Interfaces.Encryption;

namespace Service.Layer.EncryptionService.Encryption.Asymmetric
{
    public class Rsa : IEncrpytionProvider
    {
        public string Encrypt(string plaintext)
        {
            var rsa = RsaCryptoServiceProvider("InternalPublicKeyFolder");
            var cipherTextByteArray = rsa.Encrypt(Encoding.UTF8.GetBytes(plaintext), false);
            var cipherTextBase64String = Convert.ToBase64String(cipherTextByteArray);

            rsa.Clear();

            return cipherTextBase64String;
        }

        public string Decrypt(string cipherTextBase64)
        {
            var rsa = RsaCryptoServiceProvider("InternalPrivateKeyFolder");
            var plainTextByteArray = rsa.Decrypt(Convert.FromBase64String(cipherTextBase64), false);
            var plainTextString = Encoding.UTF8.GetString(plainTextByteArray);

            rsa.Clear();

            return plainTextString;
        }

        private static RSACryptoServiceProvider RsaCryptoServiceProvider(string fileLocation)
        {
            // Initailize the CSP
            // Supresses creation of a new key
            var csp = new CspParameters {ProviderType = 1, KeyNumber = 1};

            // Initialize the Provider
            //Do not add key to registry
            var cryptoServiceProvider = new RSACryptoServiceProvider(csp) {PersistKeyInCsp = false};
            var internalFileLoc = ConfigurationManager.AppSettings[fileLocation];

            //The private key string we will use to encrypt with
            string xmlKey;
            using (var reader = new StreamReader(internalFileLoc))
            {
                xmlKey = reader.ReadLine();
            }

            //set the key for the rsaCryptoServiceProvider
            if (xmlKey != null)
            {
                cryptoServiceProvider.FromXmlString(xmlKey);
            }

            //Return the provider to be used in the encrypt/decrypt methods
            return cryptoServiceProvider;
        }
    }
}