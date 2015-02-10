using AutoMapper;

using Business.Logic.Layer.Models.TaskRunnerModels;

using Core.Library.Extensions;

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