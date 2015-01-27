using SqlAgentUIRunner.Models.TaskRunnerModels;

using TaskRunner.Core.Reflector;

namespace SqlAgentUIRunner.Infrastructure.Manager
{
    public interface IServiceBusMessageManager
    {
        TaskRunnerMessagesModel BuildMessagesModel();
        TaskRunnerPropertiesModel BuildPropertiesModel(string selectedMessageName);
        void SendMessage(string typeName, PropertyWithValue[] propertiesForMessage);
    }
}