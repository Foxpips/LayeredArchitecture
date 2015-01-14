using System;
using System.Configuration;
using System.IO;

using NUnit.Framework;

using Service.Layer.EncryptionService.Encryption.Symmetric;
using Service.Layer.EncryptionService.KeyCreation.Keys;
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

        [Test]
        public void Symmetric_BaseClass_NotImplemented()
        {
            var providerBase = new SymmetricEncryptionProviderBase("", "");

            Assert.Throws<NotImplementedException>(() => providerBase.Encrypt(""));
            Assert.Throws<NotImplementedException>(() => providerBase.Decrypt(""));
        }

        [Test]
        public void RsaKey_TestedBehavior_ExpectedResult()
        {
            var rsaKey = new RsaKey();

            Directory.Delete(ConfigurationManager.AppSettings["RsaKeyFolder"],true);
            rsaKey.CreateKeys();

            Assert.That(Directory.Exists(ConfigurationManager.AppSettings["RsaKeyFolder"]),Is.True);
        }
    }
}