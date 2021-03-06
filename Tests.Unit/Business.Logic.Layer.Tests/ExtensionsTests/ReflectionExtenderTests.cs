﻿using System;

using Business.Logic.Layer.Extensions;
using Business.Objects.Layer.Pocos.Reflection;

using NUnit.Framework;

namespace Tests.Unit.Business.Logic.Layer.Tests.ExtensionsTests
{
    public class ReflectionExtenderTests
    {
        [Test]
        public void ReflectionExtender_ObjectSetValue_True()
        {
            var instance = new Test();

            const string value = "Hello World!";
            instance.SetPublicProperties(new[]
            {new PropertyWithValue {Name = "Text", Value = value}});

            Assert.That(instance.Text.Equals(value, StringComparison.OrdinalIgnoreCase), Is.True);
        }

        public class Test
        {
            public string Text { get; set; }
        }
    }
}