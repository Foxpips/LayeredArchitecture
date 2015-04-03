using Business.Logic.Layer.Helpers;

using NUnit.Framework;

using Service.Layer.EncryptionService.KeyCreation.Keys;

namespace Tests.Unit.Business.Logic.Layer.Tests.HelpersTests
{
    public class NativeTypeCheckerTests
    {
        [Test]
        public void CheckNativeType_TestedBehavior_ExpectedResult()
        {
            const string testString = "asd";

            var rsaKey = new RsaKey();
            Assert.That(() => TypeCheckerHelper.IsNativeType(testString), Is.True);
            Assert.That(() => TypeCheckerHelper.IsNativeType(rsaKey), Is.False);
        }
    }
}