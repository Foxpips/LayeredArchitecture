using System.Linq;
using System.Reflection;

using SqlAgentUIRunner.Models.TaskRunnerModels;

using TaskRunner.Core.Reflector;

namespace SqlAgentUIRunner.Infrastructure.Manager
{
    public class ServiceBusMessageManager
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
            var selectedType = DomainHelper.GetTypeFromAssembly(selectedMessageName);
            var message = new TaskRunnerPropertiesModel();

            if (selectedType != null)
            {
                message.Properties.AddRange(selectedType
                    .GetProperties()
                    .Select(property => new CustomTypePropertyModel {Name = property.Name, Id = property.Name}));
            }
            return message;
        }

        public void SendMessage(string typeName, PropertyWithValue[] propertiesForMessage)
        {
            var messageType = Reflector.GetMessageType(typeName, Path);

            if (propertiesForMessage.Any())
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