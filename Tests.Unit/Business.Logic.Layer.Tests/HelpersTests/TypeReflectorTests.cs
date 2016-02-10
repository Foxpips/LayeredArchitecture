using System;
using System.Collections.Generic;
using System.ComponentModel;
using Business.Logic.Layer.Helpers.Reflector;
using NUnit.Framework;

namespace Tests.Unit.Business.Logic.Layer.Tests.HelpersTests
{
    public class TypeReflectorTests
    {
        private TypeReflector _typeReflector;

        [SetUp]
        public void SetUp()
        {
            _typeReflector = new TypeReflector();
        }

        [Test]
        public void Reflector_GetProperties_WithAttributes()
        {
            var types = new List<Type> { typeof(DisplayNameAttribute) };
            _typeReflector.GetPropertiesWithAttributes("Dog", types);
        }
    }
}