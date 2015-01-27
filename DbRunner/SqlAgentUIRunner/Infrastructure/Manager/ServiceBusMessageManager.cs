using System.Linq;
using System.Reflection;

using SqlAgentUIRunner.Models.TaskRunnerModels;

using TaskRunner.Core.Reflector;

namespace SqlAgentUIRunner.Infrastructure.Manager
{
    public class ServiceBusMessageManager : IServiceBusMessageManager
    {
        private IReflector Reflector { get; set; }
        private string Path { get; set; }

        public ServiceBusMessageManager(IReflector reflector, string path)
        {
            Reflector = reflector;
            Path = path;
            Assembly.LoadFile(Path);
        }

        public TaskRunnerMessagesModel BuildMessagesModel()
        {
            return new TaskRunnerMessagesModel(Reflector.GetTypesFromDll(Path));
        }

        public TaskRunnerPropertiesModel BuildPropertiesModel(string selectedMessageName)
        {
            var selectedType = Reflector.GetMessageType(selectedMessageName);
            var propertiesModel = new TaskRunnerPropertiesModel();

            if (selectedType != null)
            {
                propertiesModel.Properties.AddRange(selectedType
                    .GetProperties()
                    .Select(property => new CustomTypePropertyModel {Name = property.Name, Id = property.Name}));
            }
            return propertiesModel;
        }

        public void SendMessage(string typeName, PropertyWithValue[] propertiesForMessage)
        {
            var messageType = Reflector.GetMessageType(typeName);

            if (propertiesForMessage != null && propertiesForMessage.Any())
            {
                Reflector.SendMessage(messageType, propertiesForMessage);
            }
            else
            {
                Reflector.SendMessage(messageType);
            }
        }
    }
}