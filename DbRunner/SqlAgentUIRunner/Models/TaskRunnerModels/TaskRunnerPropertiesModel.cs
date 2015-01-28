using System.Collections.Generic;

namespace SqlAgentUIRunner.Models.TaskRunnerModels
{
    public class TaskRunnerPropertiesModel
    {
        public List<TaskRunnerPropertyModel> Properties { get; set; }

        public TaskRunnerPropertiesModel()
        {
            Properties = new List<TaskRunnerPropertyModel>();
        }
    }
}