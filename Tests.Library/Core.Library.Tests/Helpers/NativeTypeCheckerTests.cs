using Core.Library.Helpers;

using NUnit.Framework;

using Service.Layer.EncryptionService.KeyCreation.Keys;

namespace Tests.Library.Core.Library.Tests.Helpers
{
    public class NativeTypeCheckerTests
    {
        [Test]
        public void CheckNativeType_TestedBehavior_ExpectedResult()
        {
            const string testString = "asd";

            var rsaKey = new RsaKey();
            Assert.That(() => TypeChecker.IsNativeType(testString), Is.True);
            Assert.That(() => TypeChecker.IsNativeType(rsaKey), Is.False);
        }
    }
}