using AutoMapper;

using Core.Library.Extensions;

using SqlAgentUIRunner.Models.TaskRunnerModels;

using TaskRunner.Core.Reflector;

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