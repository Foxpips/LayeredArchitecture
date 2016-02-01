using System.Configuration;
using System.IO;
using System.Security.Cryptography;

using Service.Layer.EncryptionService.KeyCreation.Builders;

namespace Service.Layer.EncryptionService.KeyCreation.Keys
{
    public sealed class RsaKey : IKey
    {
        //Set the key parameters
        private readonly RSACryptoServiceProvider _rsa;

        public RsaKey()
        {
            var csp = new CspParameters { ProviderType = 1, KeyNumber = 1 };
            _rsa = new RSACryptoServiceProvider(2048, csp)
            {
                PersistKeyInCsp = false
            };
        }

        public void CreateKeys()
        {
            CreateKeyStorageDirectory();
            GeneratePublicKey();
            GeneratePrivateKey();
        }

        private static void CreateKeyStorageDirectory()
        {
            var keyDirectory = ConfigurationManager.AppSettings["RsaKeyFolder"];
            if (!Directory.Exists(keyDirectory))
            {
                Directory.CreateDirectory(keyDirectory);
            }
        }

        public void GeneratePublicKey()
        {
            //Create Public Key
            var publicKey = _rsa.ExportParameters(false);
            var pkcs8Key = AsnKeyBuilder.PublicKeyToX509(publicKey);
            var xmlKey = _rsa.ToXmlString(false);
            var threeFileLoc = ConfigurationManager.AppSettings["ThreePublicKeyFolder"];
            var internalFileLoc = ConfigurationManager.AppSettings["InternalPublicKeyFolder"];

            //Write the generated public key in pkcs8Key format to a file to be used by Three
            using (var writer = new BinaryWriter(new FileStream(threeFileLoc, FileMode.Create, FileAccess.ReadWrite)))
            {
                writer.Write(pkcs8Key.GetBytes());
            }

            //Write the generated public key in xml format to a file to be used by us
            using (var writer = new StreamWriter(new FileStream(internalFileLoc, FileMode.Create, FileAccess.ReadWrite)))
            {
                writer.Write(xmlKey);
            }
        }

        public void GeneratePrivateKey()
        {
            //Create Private Key
            var privateKey = _rsa.ExportParameters(true);
            var pkcs8Key = AsnKeyBuilder.PrivateKeyToPKCS8(privateKey);
            var xmlKey = _rsa.ToXmlString(true);
            var threeFileLoc = ConfigurationManager.AppSettings["ThreePrivateKeyFolder"];
            var internalFileLoc = ConfigurationManager.AppSettings["InternalPrivateKeyFolder"];

            //Write the generated private key in pkcs8Key format to a file to be used by Three
            using (var writer = new BinaryWriter(new FileStream(threeFileLoc, FileMode.Create, FileAccess.ReadWrite)))
            {
                writer.Write(pkcs8Key.GetBytes());
            }

            //Write the generated private key in xml format to a file to be used by us
            using (var writer = new StreamWriter(
                new FileStream(internalFileLoc, FileMode.Create, FileAccess.ReadWrite)))
            {
                writer.Write(xmlKey);
            }

            //Clear the rsa session
            _rsa.Clear();
        }
    }
}