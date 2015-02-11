using System.Linq;
using System.Reflection;

using AutoMapper;

using Business.Objects.Layer.Interfaces.Reflection;
using Business.Objects.Layer.Models.TaskRunnerModels;
using Business.Objects.Layer.Pocos.Reflection;

namespace Business.Logic.Layer.Managers.ServiceBus
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
                    .Select(property => new TaskRunnerPropertyModel {Name = property.Name, Id = property.Name}));
            }
            return propertiesModel;
        }

        public void SendMessage(string typeName, TaskRunnerPropertyModel[] propertiesForMessage)
        {
            var messageType = Reflector.GetMessageType(typeName);

            if (propertiesForMessage != null && propertiesForMessage.Any())
            {
                Reflector.SendMessage(messageType, Mapper.Map<PropertyWithValue[]>(propertiesForMessage));
                return;
            }

            Reflector.SendMessage(messageType);
        }
    }
}