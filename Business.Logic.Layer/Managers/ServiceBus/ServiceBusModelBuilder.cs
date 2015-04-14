using System;
using System.Linq;
using System.Reflection;

using Business.Objects.Layer.Interfaces.Reflection;
using Business.Objects.Layer.Interfaces.ServiceBus;
using Business.Objects.Layer.Models.TaskRunner;

namespace Business.Logic.Layer.Managers.ServiceBus
{
    public class ServiceBusModelBuilder : IServiceBusModelBuilder
    {
        private IReflector Reflector { get; set; }
        private string Path { get; set; }

        public ServiceBusModelBuilder(IReflector reflector, string path)
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
                    .Select(
                        property =>
                            new TaskRunnerPropertyModel
                            {
                                Name = property.Name + " (" + property.PropertyType + ")",
                                Id = property.Name
                            }));
            }
            return propertiesModel;
        }

        public Type GetMessage(string typeName)
        {
            return Reflector.GetMessageType(typeName);
        }
    }
}