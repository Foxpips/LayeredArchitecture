using System.IO;

using Framework.Layer.Handlers;
using Framework.Layer.Handlers.Methods;

using Newtonsoft.Json;

namespace Core.Library.Helpers
{
    public class JsonHelper
    {
        public static TType DeserializeJson<TType>(string json)
        {
            return SafeExecutionHandler.Try(() => JsonConvert.DeserializeObject<TType>(json));
        }

        public static string SerializeJson<TType>(TType item)
        {
            return SafeExecutionHandler.Try(() => JsonConvert.SerializeObject(item));
        }

        public static TType DeserializeJsonFromFile<TType>(string filePath)
        {
            return SafeExecutionHandler.Try(() =>
            {
                var content = File.ReadAllText(filePath);
                return JsonConvert.DeserializeObject<TType>(content);
            });
        }

        public static void SerializeJsonToFile<TType>(TType item, string path)
        {
            SafeExecutionHandler.Try(() =>
            {
                var serializedObject = JsonConvert.SerializeObject(item);
                File.WriteAllText(path, serializedObject);
            });
        }
    }
}