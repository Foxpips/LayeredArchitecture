using System;

using NUnit.Framework;

using Service.Layer.EncryptionService.Encryption.Symmetric;
using Service.Layer.EncryptionService.Services;

namespace Tests.Library.Service.Layer.Tests.EncryptionTests
{
    public class TestSymmetricEncryption
    {
        [Test]
        public void TripleDesEncryptionTest()
        {
            const string testString = "Test";

            var encryptionProviderService = new EncryptionProviderService<TripleDes>();
            var ciphertext = encryptionProviderService.Encrypt(testString);
            Console.WriteLine(ciphertext);

            var plaintext = encryptionProviderService.Decrypt(ciphertext);
            Console.WriteLine(plaintext);

            Assert.That(plaintext, Is.EqualTo(testString));
        }

        [Test]
        public void AesEncryptionTest()
        {
            const string testString = "Test";

            var encryptionProviderService = new EncryptionProviderService<Aes>();
            var ciphertext = encryptionProviderService.Encrypt(testString);
            Console.WriteLine(ciphertext);

            var plaintext = encryptionProviderService.Decrypt(ciphertext);
            Console.WriteLine(plaintext);

            Assert.That(plaintext, Is.EqualTo(testString));
        }
    }
}