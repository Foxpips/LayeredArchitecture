using System.Runtime.InteropServices.ComTypes;
using Business.Logic.Layer.Extensions;
using NUnit.Framework;
using Tests.Unit.Mocks;
using Tests.Unit.Mocks.EnumMocks;
using Tests.Unit.Mocks.SettingsMocks;

namespace Tests.Unit.Business.Logic.Layer.Tests.ExtensionsTests
{
    public class EnumExtenderTests
    {
        public ScheduleEnumMock EnumMock { get; private set; }

        [SetUp]
        public void SetUp()
        {
            EnumMock = ScheduleEnumMock.Daily;
        }

        [Test]
        public void EnumExtension_GetDescription_PrintsAttributeDescription()
        {
            Assert.That(EnumMock.Description().Equals(TextSettings.Daily));
        }
    }
}