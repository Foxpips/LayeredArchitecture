using System;
using System.Collections.Generic;

namespace Business.Objects.Layer.Models.TaskRunner
{
    public class TaskRunnerMessagesModel
    {
        public List<string> Messages { get; set; }

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