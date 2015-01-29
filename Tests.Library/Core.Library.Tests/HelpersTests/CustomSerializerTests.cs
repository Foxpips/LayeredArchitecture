using System;
using System.IO;
using System.Runtime.Serialization.Formatters.Soap;

using Business.Logic.Layer.Pocos.Data;

using Core.Library.Helpers;

using NUnit.Framework;

namespace Tests.Library.Core.Library.Tests.HelpersTests
{
    public class CustomSerializerTests
    {
        private string Path { get; set; }

        [SetUp]
        public void Setup()
        {
            Path = @"C:\Users\smarkey\Desktop\Movie.xml";
        }

        [Test]
        public void CustomSerializer_Soap_Serialize()
        {
            File.Delete(Path);
            SerializerHelper.Serializer<SoapFormatter, Movie>(Path,
                new Movie {Id = 1, Rating = 10, Name = "Beverly hills cop"});

            Assert.That(File.Exists(Path));
        }

        [Test]
        public void CustomSerializer_Soap_Deserialize()
        {
            const string beverlyHillsCop = "Beverly hills cop";

            SerializerHelper.Serializer<SoapFormatter, Movie>(Path,
                new Movie {Id = 1, Rating = 10, Name = beverlyHillsCop});
            var movie = SerializerHelper.DeSerializer<SoapFormatter, Movie>(Path);

            Assert.NotNull(movie);
            Assert.True(movie.Name.Equals(beverlyHillsCop, StringComparison.OrdinalIgnoreCase));
        }
    }
}