using System.IO;

using Business.Logic.Layer.Interfaces.Logging;

using Newtonsoft.Json;

namespace Core.Library.Helpers
{
    public class JsonHelper
    {
        private readonly ICustomLogger _logger;

        public JsonHelper(ICustomLogger logger)
        {
            _logger = logger;
        }

        public TType DeserializeJson<TType>(string json)
        {
            return SafeExecutionHelper.ExecuteSafely<TType, JsonSerializationException>(_logger,
                () => JsonConvert.DeserializeObject<TType>(json));
        }

        public string SerializeJson<TType>(TType item)
        {
            return SafeExecutionHelper.ExecuteSafely<string, JsonSerializationException>(_logger,
                () => JsonConvert.SerializeObject(item));
        }

        public TType DeserializeJsonFromFile<TType>(string filePath)
        {
            return SafeExecutionHelper.ExecuteSafely<TType, JsonSerializationException>(_logger, () =>
            {
                var content = File.ReadAllText(filePath);
                return JsonConvert.DeserializeObject<TType>(content);
            });
        }

        public void SerializeJsonToFile<TType>(TType item, string path)
        {
            SafeExecutionHelper.ExecuteSafely<TType, JsonSerializationException>(_logger, () =>
            {
                var serializedObject = JsonConvert.SerializeObject(item);
                File.WriteAllText(path, serializedObject);
                return default(TType);
            });
        }
    }
}