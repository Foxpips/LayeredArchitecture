using NUnit.Framework;

using Service.Layer.EncryptionService.KeyCreation.Keys;
using Service.Layer.EncryptionService.Services;

namespace Tests.Library.Service.Layer.Tests.EncryptionTests
{
    public class TestKeyCreation
    {
        [Test]
        public void MethodUnderTest_TestedBehavior_ExpectedResult()
        {
            EncryptionKeyBuilderService<RsaKey>.GenerateKeys();
        }
    }
}