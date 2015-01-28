using SqlAgentUIRunner.Models.TaskRunnerModels;

namespace SqlAgentUIRunner.Infrastructure.Manager
{
    public interface IServiceBusMessageManager
    {
        TaskRunnerMessagesModel BuildMessagesModel();
        TaskRunnerPropertiesModel BuildPropertiesModel(string selectedMessageName);
        void SendMessage(string typeName, TaskRunnerPropertyModel[] propertiesForMessage);
    }
}