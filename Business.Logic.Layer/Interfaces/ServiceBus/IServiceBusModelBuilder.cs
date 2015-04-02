using System;

using Business.Objects.Layer.Models.TaskRunner;

namespace Business.Objects.Layer.Interfaces.ServiceBus
{
    public interface IServiceBusModelBuilder
    {
        TaskRunnerMessagesModel BuildMessagesModel();
        TaskRunnerPropertiesModel BuildPropertiesModel(string selectedMessageName);
        Type GetMessage(string typeName);
    }
}