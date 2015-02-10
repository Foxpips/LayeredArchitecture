using Business.Logic.Layer.Models.TaskRunnerModels;

namespace Core.Library.Managers.ServiceBus
{
    public interface IServiceBusMessageManager
    {
        TaskRunnerMessagesModel BuildMessagesModel();
        TaskRunnerPropertiesModel BuildPropertiesModel(string selectedMessageName);
        void SendMessage(string typeName, TaskRunnerPropertyModel[] propertiesForMessage);
    }
}