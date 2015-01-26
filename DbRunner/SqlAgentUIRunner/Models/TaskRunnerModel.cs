using System;
using System.Collections.Generic;

using SqlAgentUIRunner.Controllers;

namespace SqlAgentUIRunner.Models
{
    public class TaskRunnerModel
    {
        public List<string> Messages { get; set; }

        public TaskRunnerModel(IEnumerable<Type> typesFromDll)
        {
            Messages = new List<string>();

            foreach (var type in typesFromDll)
            {
                Messages.Add(type.Name);
            }
        }
    }

    public class TaskRunnerPropertiesModel
    {
        public List<CustomTypeProperty> Properties { get; set; }

        public TaskRunnerPropertiesModel()
        {
            Properties = new List<CustomTypeProperty>();
        }
    }
}