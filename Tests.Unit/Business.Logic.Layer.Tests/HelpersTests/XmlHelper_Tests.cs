using System.IO;

using Business.Logic.Layer.Helpers;
using Business.Objects.Layer.Pocos.Data;

using NUnit.Framework;

namespace Tests.Unit.Business.Logic.Layer.Tests.HelpersTests
{
    [TestFixture]
    public class XmlHelperTests
    {
        [Test]
        public void Deserialize_Movie_XmlTest()
        {
            var movie =
                XmlHelper.DeserializeXml<Movie>(
                    @"..\..\Business.Logic.Layer.Tests\SampleXml\SampleXml - Movie.json");

            Assert.That(movie, Is.Not.Null);
            Assert.That(movie.Id.Equals(1));
            Assert.That(movie.Name.Equals("John Carter"));
        }

        [Test]
        public void Serialize_Movie_XmlTest()
        {
            const string path =
                @"..\..\Business.Logic.Layer.Tests\SampleXml\SampleXml - MovieOutput.json";

            if (File.Exists(path))
            {
                File.Delete(path);
            }

            const string movieName = "The Princess Bride";
            XmlHelper.SerializeXml(
                path,
                new Movie
                {
                    Id = 2,
                    Name = movieName,
                    Rating = 9
                });

            Assert.That(File.Exists(path));
            var movie = XmlHelper.DeserializeXml<Movie>(path);

            Assert.That(movie.Name.Equals(movieName));
        }
    }
}