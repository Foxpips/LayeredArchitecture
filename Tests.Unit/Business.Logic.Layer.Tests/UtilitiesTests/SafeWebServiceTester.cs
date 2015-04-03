using System;

using Business.Objects.Layer.Exceptions.Basic;

using Framework.Layer.Logging.LogTypes;

using NUnit.Framework;

namespace Tests.Unit.Business.Logic.Layer.Tests.UtilitiesTests
{
    public class SafeWebServiceTester
    {
        private SafeWebServiceTests _safeWebServiceTests;

        [SetUp]
        public void SetUp()
        {
            _safeWebServiceTests = new SafeWebServiceTests(new ConsoleLogger());
        }

        [Test]
        public void Test_SafeWebService_Execute()
        {
            Assert.True(_safeWebServiceTests.SafeWebServiceExecute());
        }

        [Test]
        public void Test_SafeWebService_ThrowApiSoapException()
        {
            Assert.Throws<ApiSoapException>(_safeWebServiceTests.SafeWebServiceThrowApiSoapException);
        }

        [Test]
        public void Test_SafeWebService_ThrowApiException()
        {
            Assert.Throws<ApiException>(_safeWebServiceTests.SafeWebServiceThrowApiException);
        }

        [Test]
        public void Test_SafeWebService_ThrowException()
        {
            Assert.Throws<Exception>(_safeWebServiceTests.SafeWebServiceThrowException);
        }
    }
}