using System.IO;
using System.Runtime.Serialization;

namespace Core.Library.Helpers
{
    public class SerializerHelper
    {
        public static void Serializer<TFormatter, TType>(string path, TType type)
            where TFormatter : IFormatter, new()
        {
            var serializer = new TFormatter();
            using (
                Stream stream = new FileStream(path, FileMode.Create, FileAccess.Write,
                    FileShare.None))
            {
                serializer.Serialize(stream, type);
            }
        }

        public static TType DeSerializer<TFormatter, TType>(string path)
            where TFormatter : IFormatter, new()
        {
            var serializer = new TFormatter();
            using (
                Stream stream = new FileStream(path, FileMode.Open, FileAccess.Read,
                    FileShare.Read))
            {
                return (TType) serializer.Deserialize(stream);
            }
        }
    }
}