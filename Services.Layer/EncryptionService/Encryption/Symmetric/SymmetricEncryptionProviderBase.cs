using System;
using System.IO;
using System.Security.Cryptography;
using System.Text;

using Core.Library.Exceptions.Generic;
using Core.Library.Exceptions.Generic.Args;

namespace Service.Layer.EncryptionService.Encryption.Symmetric
{
    public class SymmetricEncryptionProviderBase : IEncrpytionProvider
    {
        protected byte[] _iv;
        protected byte[] _key;

        protected SymmetricEncryptionProviderBase(string key, string initializationVector)
        {
            _iv = Encoding.ASCII.GetBytes(initializationVector);
            _key = Encoding.ASCII.GetBytes(key);
        }

        public virtual string Encrypt(string plaintext)
        {
            throw new NotImplementedException("The functionality for encryption is defined only in the subclasses");
        }

        public virtual string Decrypt(string ciphertext)
        {
            throw new NotImplementedException("The functionality for decryption is defined only in the subclasses");
        }

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