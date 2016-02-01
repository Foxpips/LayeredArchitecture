using System.Security.Cryptography;

using NUnit.Framework;

using Service.Layer.EncryptionService.Encryption.Symmetric;
using Service.Layer.EncryptionService.Services;

using Aes = Service.Layer.EncryptionService.Encryption.Symmetric.Aes;

namespace Tests.Unit.Framework.Layer.Tests.LoggingTests
{
    public class BaseLoggerTests : SymmetricEncryptionProviderBase
    {
        public BaseLoggerTests(string key, string initializationVector) : base(key, initializationVector)
        {
        }

        public BaseLoggerTests() : this("adfhdsiajnlfo4389525j329", "I%d*2K5G91Vb+~#|")
        {
        }

        [Test]
        public void MethodUnderTest_TestedBehavior_Array()
        {
            var encryptionProviderService = new EncryptionProviderService<Aes>();
            var encrypt = encryptionProviderService.Encrypt("Test Text");
            var decrypt = encryptionProviderService.Decrypt(encrypt);
            Assert.That(decrypt, Is.EqualTo("Test Text"));
        }

        [Test]
        public void MethodUnderTest_TestedBehavior_ExpectedResult()
        {
            var decryptor = new AesCryptoServiceProvider().CreateDecryptor(_key, _iv);

            Assert.Throws<CryptographicException>(
                () => ExecuteCryptoServiceProvider(new byte[10], decryptor));
        }

        public override string Encrypt(string plaintext)
        {
            throw new System.NotImplementedException();
        }

        public override string Decrypt(string ciphertext)
        {
            throw new System.NotImplementedException();
        }
    }
}