using System;

using Core.Library.Exceptions.Basic;

using Dependency.Resolver;

using NUnit.Framework;

using Tests.Library.Mocks.ApiMocks;
using Tests.Library.Mocks.ApiMocks.Responses;

namespace Tests.Library.Core.Library.Tests.UtilitiesTests
{
    public class SafeApiBaseTests
    {
        private ReflectorApiMock ReflectorApiMock { get; set; }

        [SetUp]
        public void SetUp()
        {
            DependencyInjectionLoader.ConfigureDependencies();
            ReflectorApiMock = new ReflectorApiMock("username", "password");
        }

        [Test]
        public void SendRequest_UsingSafeApi_SendsMockMessage()
        {
            Response response = ReflectorApiMock.SendSellItemRequest();

            Assert.That(response.Data.Equals("Success", StringComparison.OrdinalIgnoreCase), Is.True);
        }

        [Test]
        public void ThrowApiException_UsingSafeApi_True()
        {
            Assert.Throws<ApiException>(() => ReflectorApiMock.SendPurchaseItemRequest());
        }

        [Test]
        public void ThrowApiSoapException_UsingSafeApi_True()
        {
            Assert.Throws<ApiSoapException>(() => ReflectorApiMock.SendReturnItemRequest());
        }
    }
}