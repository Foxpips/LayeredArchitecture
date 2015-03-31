using System.IO;
using System.Xml.Serialization;

namespace Business.Logic.Layer.Helpers
{
    public class XmlHelper
    {
        public static TType DeserializeXml<TType>(string path)
        {
            var serializer = new XmlSerializer(typeof (TType));

            using (var reader = new StreamReader(path))
            {
                return (TType) serializer.Deserialize(reader);
            }
        }

        public static void SerializeXml<TType>(string path, TType instance) where TType : new()
        {
            var serializer = new XmlSerializer(typeof (TType));

            using (var writer = new FileStream(path, FileMode.Create))
            {
                serializer.Serialize(writer, instance);
            }
        }
    }
}