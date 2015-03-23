using AutoMapper;

using Business.Logic.Layer.Models.TaskRunner;
using Business.Logic.Layer.Pocos.Reflection;

namespace SqlAgentUIRunner.Infrastructure.Mappers
{
    public class AutoMapperConfig
    {
        public static void RegisterMappings()
        {
            Mapper.CreateMap<TaskRunnerPropertyModel, PropertyWithValue>();
        }
    }
}