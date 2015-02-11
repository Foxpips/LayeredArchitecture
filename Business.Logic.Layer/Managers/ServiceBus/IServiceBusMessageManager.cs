using Business.Objects.Layer.Models.TaskRunnerModels;

namespace Business.Logic.Layer.Managers.ServiceBus
{
    public interface IServiceBusMessageManager
    {
        TaskRunnerMessagesModel BuildMessagesModel();
        TaskRunnerPropertiesModel BuildPropertiesModel(string selectedMessageName);
        void SendMessage(string typeName, TaskRunnerPropertyModel[] propertiesForMessage);
    }
}