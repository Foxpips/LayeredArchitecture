using System.IO;

using Newtonsoft.Json;

namespace Core.Library.Helpers
{
    public class JsonHelper
    {
        public static TType DeserializeJson<TType>(string json)
        {
            return
                SafeExecutionHelper.ExecuteSafely<TType, JsonSerializationException>(() =>
                    JsonConvert.DeserializeObject<TType>(json));
        }

        public static string SerializeJson<TType>(TType item)
        {
            return SafeExecutionHelper.ExecuteSafely<string, JsonSerializationException>(() =>
                JsonConvert.SerializeObject(item));
        }

        public static TType DeserializeJsonFromFile<TType>(string filePath)
        {
            return SafeExecutionHelper.ExecuteSafely<TType, JsonSerializationException>(() =>
            {
                var content = File.ReadAllText(filePath);
                return JsonConvert.DeserializeObject<TType>(content);
            });
        }

        public static void SerializeJsonToFile<TType>(TType item, string path)
        {
            SafeExecutionHelper.ExecuteSafely<TType, JsonSerializationException>(() =>
            {
                var serializedObject = JsonConvert.SerializeObject(item);
                File.WriteAllText(path, serializedObject);
                return default(TType);
            });
        }
    }
}