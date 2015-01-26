using System;
using System.Collections.Generic;

namespace SqlAgentUIRunner.Models
{
    public class TaskRunnerModel
    {
        public TaskRunnerModel(IEnumerable<Type> typesFromDll)
        {
            Messages = new List<string>();
            Properties = new List<string>();

            foreach (var type in typesFromDll)
            {
                Messages.Add(type.Name);
            }
        }

        public List<string> Messages { get; set; }
        public List<string> Properties { get; set; }
    }

    public class MessageCommand
    {
        public string Name { get; set; }

        public MessageCommand(string name)
        {
            Name = name;
        }
    }
}