using System.Collections.Generic;

namespace Business.Logic.Layer.Models.TaskRunner
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