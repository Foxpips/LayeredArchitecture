using System.IO;

using Framework.Layer.Handlers;

using Newtonsoft.Json;

namespace Core.Library.Helpers
{
    public class JsonHelper
    {
        public static TType DeserializeJson<TType>(string filename, string directory)
        {
            return SafeExecutionHandler.Try(() =>
            {
                var content = File.ReadAllText(Path.Combine(directory, filename));
                return JsonConvert.DeserializeObject<TType>(content);
            });
        }

        public static void SerializeJson<TType>(TType item, string path)
        {
            SafeExecutionHandler.Try(() =>
            {
                var serializedObject = JsonConvert.SerializeObject(item);
                File.WriteAllText(path, serializedObject);
            });
        }
    }
}