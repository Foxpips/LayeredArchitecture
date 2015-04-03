using System;

using Business.Logic.Layer.Helpers;

using NUnit.Framework;

namespace Tests.Unit.Business.Logic.Layer.Tests.HelpersTests
{
    public class DomainHelperTests
    {
        [Test]
        public void DomainHelper_GetTypeFromAssembly_True()
        {
            var typeName = typeof (PseduoDHelperClass).Name;
            var typeFromAssembly = DomainHelper.GetTypeFromAssembly(typeName);

            Assert.That(typeFromAssembly.Name.Equals(typeName, StringComparison.OrdinalIgnoreCase), Is.True);
        }

        public class PseduoDHelperClass
        {
        }
    }
}