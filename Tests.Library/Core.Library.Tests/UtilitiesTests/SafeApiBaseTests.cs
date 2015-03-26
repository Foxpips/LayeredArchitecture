using System;

using Business.Logic.Layer.Interfaces.Logging;

using Core.Library.Exceptions.Basic;

using Dependency.Resolver.Loaders;

using NUnit.Framework;

using Tests.Unit.Mocks.ApiMocks;
using Tests.Unit.Mocks.ApiMocks.Responses;

namespace Tests.Unit.Core.Library.Tests.UtilitiesTests
{
    public class SafeApiBaseTests
    {
        private ReflectorApiMock ReflectorApiMock { get; set; }

        [SetUp]
        public void SetUp()
        {
            var dependencyManager = new DependencyManager();
            dependencyManager.ConfigureStartupDependencies();

            var logger = dependencyManager.Container.GetInstance<ICustomLogger>();

            ReflectorApiMock = new ReflectorApiMock("username", "password",
                logger);
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