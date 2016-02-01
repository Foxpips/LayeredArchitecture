using System;
using System.IO;
using System.Security.Cryptography;
using System.Text;
using Business.Objects.Layer.Exceptions.Generic;
using Business.Objects.Layer.Exceptions.Generic.Args;
using Business.Objects.Layer.Interfaces.Encryption;

namespace Service.Layer.EncryptionService.Encryption.Symmetric
{
    public abstract class SymmetricEncryptionProviderBase : IEncrpytionProvider
    {
        protected byte[] _iv;
        protected byte[] _key;

        protected SymmetricEncryptionProviderBase(string key, string initializationVector)
        {
            _iv = Encoding.ASCII.GetBytes(initializationVector);
            _key = Encoding.ASCII.GetBytes(key);
        }

        public abstract string Encrypt(string plaintext);
        public abstract string Decrypt(string ciphertext);

        protected static byte[] ExecuteCryptoServiceProvider(byte[] data, ICryptoTransform cryptoTransform)
        {
            byte[] inArray;
            using (var memoryStream = new MemoryStream())
            {
                using (var cryptoStream = new CryptoStream(memoryStream,
                    cryptoTransform, CryptoStreamMode.Write))
                {
                    try
                    {
                        cryptoStream.Write(data, 0, data.Length);
                        cryptoStream.FlushFinalBlock();
                    }
                    catch (Exception ex)
                    {
                        throw new CustomException<CryptoServiceExceptionArgs>(
                            new CryptoServiceExceptionArgs("Error while writing encrypted data to the stream: \n" +
                                                           ex.Message));
                    }
                    finally
                    {
                        cryptoStream.Dispose();
                    }
                }

                inArray = memoryStream.ToArray();
            }

            return inArray;
        }
    }
}