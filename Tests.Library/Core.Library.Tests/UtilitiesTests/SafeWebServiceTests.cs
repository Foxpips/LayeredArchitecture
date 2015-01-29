using System;
using System.Xml;

using Core.Library.Exceptions.Basic;
using Core.Library.Utilities.WebApi;

using NUnit.Framework;

namespace Tests.Library.Core.Library.Tests.UtilitiesTests
{
    public class SafeWebServiceTests : SafeWebService
    {
        [Test]
        public void Test_SafeWebService_Execute()
        {
            var s = false;

            Execute(() => s = true);

            Assert.True(s);
        }

        [Test]
        public void Test_SafeWebService_ThrowApiSoapException()
        {
            Assert.Throws<ApiSoapException>(
                () =>
                    Execute<object>(
                        () => { throw new ApiSoapException("Error", new XmlQualifiedName(), new Exception()); }));
        }

        [Test]
        public void Test_SafeWebService_ThrowApiException()
        {
            Assert.Throws<ApiException>(
                () =>
                    Execute<object>(
                        () => { throw new ApiException("Error", new XmlQualifiedName(), new Exception()); }));
        }

        [Test]
        public void Test_SafeWebService_ThrowException()
        {
            Assert.Throws<Exception>(
                () =>
                    Execute<object>(
                        () => { throw new Exception("Error"); }));
        }
    }
}