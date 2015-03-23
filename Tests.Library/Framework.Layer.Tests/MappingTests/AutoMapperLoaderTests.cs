using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;

using AutoMapper;

using Business.Logic.Layer.Interfaces.AutoMapper;
using Business.Logic.Layer.Models.TaskRunner;
using Business.Logic.Layer.Pocos.Reflection;

using Framework.Layer.Loaders.Mapping;

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

        [Test]
        public void AnimalMapping_TestedBehavior_ExpectedResult()
        {
            ExportedTypes = Assembly.GetExecutingAssembly().ExportedTypes.ToList();
            AutoMapperLoader.LoadAllMappings(ExportedTypes);

            var animal = new Animal {Name = "Doberman"};
            var dog = Mapper.Map<Dog>(animal);
            var dober = Mapper.Map<DoberMan>(dog);

            Console.WriteLine(dober.Name);
        }

        [Test]
        public void PropertyWithValueMapping_TestedBehavior_ExpectedResult()
        {
            ExportedTypes = typeof (TaskRunnerPropertyModel).Assembly.ExportedTypes.ToList();
            AutoMapperLoader.LoadAllMappings(ExportedTypes);

            var taskRunnerPropertyModel = new TaskRunnerPropertyModel {Name = "Cool", Id = "1", Value = "100"};
            var propertyWithValue = Mapper.Map<PropertyWithValue>(taskRunnerPropertyModel);

            Console.WriteLine(propertyWithValue.Name);
        }

        [Test]
        public void Dogmappings_TestedBehavior_ExpectedResult()
        {
            Mapper.CreateMap<Animal, Dog>();

            var animal = new Animal {Name = "Doberman"};

            var dog = Mapper.Map<Dog>(animal);

            Console.WriteLine(dog.Name);
            Assert.That(dog.Name.Equals("Doberman", StringComparison.OrdinalIgnoreCase));
        }

        public class Animal
        {
            public string Name { get; set; }
        }

        public class Dog : IMapTo<DoberMan, Animal>, IMapFrom<Animal>
        {
            public string Name { get; set; }
        }

        public class DoberMan
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