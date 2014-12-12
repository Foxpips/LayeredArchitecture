using System;

using NUnit.Framework;

using Service.Layer.EncryptionService.Encryption.Asymmetric;
using Service.Layer.EncryptionService.KeyCreation.Keys;
using Service.Layer.EncryptionService.Services;

namespace Tests.Library.Service.Layer.Tests.EncryptionTests
{
    public class TestAsymmetricEncryption
    {
        [SetUp]
        public void Setup()
        {
            EncryptionKeyBuilderService<RsaKey>.GenerateKeys();
        }

        [Test]
        public void RsaEncryptionTest()
        {
            const string testString = "hello";
            var encryptionProviderService = new EncryptionProviderService<Rsa>();
            var ciphertext = encryptionProviderService.Encrypt(testString);
            Console.WriteLine(ciphertext);

            var plaintext = encryptionProviderService.Decrypt(ciphertext);
            Console.WriteLine(plaintext);

            Assert.That(plaintext, Is.EqualTo(testString));
        }
    }
}