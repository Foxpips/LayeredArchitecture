using System.IO;

using Business.Logic.Layer.Pocos;

using Core.Library.Helpers;

using NUnit.Framework;

namespace Tests.Library.Core.Library.Tests.Helpers
{
    [TestFixture]
    public class XmlHelperTests
    {
        [Test]
        public void Deserialize_Movie_XmlTest()
        {
            var movie =
                XmlHelper.DeserializeXml<Movie>(
                    @"C:\Users\smarkey\Documents\GitHub\LayeredArchitecture\Tests.Library\Core.Library.Tests\SampleXml\SampleXml - Movie.json");

            Assert.That(movie, Is.Not.Null);
            Assert.That(movie.Id.Equals(1));
            Assert.That(movie.Name.Equals("John Carter"));
        }

        [Test]
        public void Serialize_Movie_XmlTest()
        {
            const string path =
                @"C:\Users\smarkey\Documents\GitHub\LayeredArchitecture\Tests.Library\Core.Library.Tests\SampleXml\SampleXml - MovieOutput.json";

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