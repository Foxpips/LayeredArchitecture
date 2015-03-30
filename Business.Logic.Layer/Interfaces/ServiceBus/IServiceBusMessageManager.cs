using System;

using Business.Logic.Layer.Models.TaskRunner;

namespace Business.Logic.Layer.Interfaces.ServiceBus
{
    public interface IServiceBusMessageManager
    {
        TaskRunnerMessagesModel BuildMessagesModel();
        TaskRunnerPropertiesModel BuildPropertiesModel(string selectedMessageName);
        Type GetMessage(string typeName);
    }
}