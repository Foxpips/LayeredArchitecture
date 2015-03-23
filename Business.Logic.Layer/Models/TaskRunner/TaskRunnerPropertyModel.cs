using Business.Logic.Layer.Interfaces.AutoMapper;
using Business.Logic.Layer.Pocos.Reflection;

namespace Business.Logic.Layer.Models.TaskRunner
{
    public class TaskRunnerPropertyModel : IMapTo<PropertyWithValue>
    {
        public string Name { get; set; }
        public string Id { get; set; }
        public string Value { get; set; }
    }
}