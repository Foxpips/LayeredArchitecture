using System.Collections.Generic;

namespace SqlAgentUIRunner.Models.TaskRunnerModels
{
    public class TaskRunnerPropertiesModel
    {
        public List<CustomTypePropertyModel> Properties { get; set; }

        public TaskRunnerPropertiesModel()
        {
            Properties = new List<CustomTypePropertyModel>();
        }
    }
}