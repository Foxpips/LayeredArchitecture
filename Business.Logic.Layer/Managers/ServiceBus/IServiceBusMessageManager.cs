using Business.Logic.Layer.Models.TaskRunner;

namespace Business.Logic.Layer.Managers.ServiceBus
{
    public interface IServiceBusMessageManager
    {
        TaskRunnerMessagesModel BuildMessagesModel();
        TaskRunnerPropertiesModel BuildPropertiesModel(string selectedMessageName);
        void SendMessage(string typeName, TaskRunnerPropertyModel[] propertiesForMessage);
    }
}