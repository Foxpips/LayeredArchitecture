﻿using Core.Library.Helpers;

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
            Assert.That(() => TypeCheckerHelper.IsNativeType(testString), Is.True);
            Assert.That(() => TypeCheckerHelper.IsNativeType(rsaKey), Is.False);
        }
    }
}