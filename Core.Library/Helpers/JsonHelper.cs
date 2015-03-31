using System.IO;

using Business.Objects.Layer.Interfaces.Logging;

using Newtonsoft.Json;

namespace Business.Logic.Layer.Helpers
{
    public class JsonHelper
    {
        private readonly SafeExecutionHelper _safeExecutionHelper;

        public JsonHelper(ICustomLogger logger)
        {
            _safeExecutionHelper = new SafeExecutionHelper(logger);
        }

        public TType DeserializeJson<TType>(string json)
        {
            return
                _safeExecutionHelper.ExecuteSafely<TType, JsonSerializationException>(ExceptionPolicy.RethrowException,
                    () =>
                        JsonConvert.DeserializeObject<TType>(json),
                    (ex, log) => log.Error("Error deserializing json: " + json + " to object " + typeof (TType)));
        }

        public string SerializeJson<TType>(TType item)
        {
            return
                _safeExecutionHelper.ExecuteSafely<string, JsonSerializationException>(ExceptionPolicy.RethrowException,
                    () =>
                        JsonConvert.SerializeObject(item),
                    (ex, log) => log.Error("Error serializing object: " + typeof (TType)));
        }

        public TType DeserializeJsonFromFile<TType>(string filePath)
        {
            return
                _safeExecutionHelper.ExecuteSafely<TType, JsonSerializationException>(ExceptionPolicy.RethrowException,
                    () =>
                    {
                        var content = File.ReadAllText(filePath);
                        return JsonConvert.DeserializeObject<TType>(content);
                    },
                    (ex, log) =>
                        log.Error("Error deserializing from file: " + filePath + " to object: " + typeof (TType)));
        }

        public void SerializeJsonToFile<TType>(TType item, string path)
        {
            _safeExecutionHelper.ExecuteSafely<TType, JsonSerializationException>(ExceptionPolicy.RethrowException,
                () =>
                {
                    var serializedObject = JsonConvert.SerializeObject(item);
                    File.WriteAllText(path, serializedObject);
                    return default(TType);
                },
                (ex, log) => log.Error("Error serializing object: " + typeof (TType) + " to file: " + path));
        }
    }
}