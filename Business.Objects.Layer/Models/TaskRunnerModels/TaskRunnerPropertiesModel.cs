using System.Collections.Generic;

namespace Business.Objects.Layer.Models.TaskRunnerModels
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