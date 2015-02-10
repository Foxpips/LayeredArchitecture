using System;
using System.Collections.Generic;

namespace Business.Logic.Layer.Models.TaskRunnerModels
{
    [Serializable]
    public class TaskRunnerMessagesModel
    {
        public List<string> Messages { get; set; }

        public TaskRunnerMessagesModel()
        {
            
        }

        public TaskRunnerMessagesModel(IEnumerable<Type> typesFromDll)
        {
            Messages = new List<string>();

            foreach (var type in typesFromDll)
            {
                Messages.Add(type.Name);
            }
        }
    }
}