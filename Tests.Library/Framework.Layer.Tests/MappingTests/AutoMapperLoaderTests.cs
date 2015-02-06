using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;

using AutoMapper;

using Framework.Layer.Mapping;

using NUnit.Framework;

namespace Tests.Library.Framework.Layer.Tests.MappingTests
{
    public class AutoMapperLoaderTests
    {
        public IEnumerable<Type> ExportedTypes { get; set; }

        [SetUp]
        public void SetUp()
        {
            ExportedTypes = Assembly.GetExecutingAssembly().ExportedTypes.ToList();
            AutoMapperLoader.LoadAllMappings(ExportedTypes);
        }

        public class Animal
        {
            public string Name { get; set; }
        }

        public class Dog : IMapTo<Animal>, IMapFrom<Animal>
        {
            public string Name { get; set; }
        }

        [Test]
        public void AutoMapperLoader_MapFrom_Success()
        {
            const string name = "Molly The Animal";
            var dog = Mapper.Map<Dog>(new Animal {Name = name});

            Assert.That(dog.Name.Equals(name));
        }

        [Test]
        public void AutoMapperLoader_MapTo_Success()
        {
            const string name = "Molly The Dog";
            var animal = Mapper.Map<Animal>(new Dog {Name = name});

            Assert.That(animal.Name.Equals(name));
        }

        [Test]
        public void TestLoadCutomMappings_AutoMapperLoader_ExpectedResult()
        {
            AutoMapperLoader.LoadAllMappings(ExportedTypes);
        }
    }
}