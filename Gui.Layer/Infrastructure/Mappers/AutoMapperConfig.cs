using AutoMapper;

using Business.Objects.Layer.Models.TaskRunner;
using Business.Objects.Layer.Pocos.Reflection;

namespace Gui.Layer.Infrastructure.Mappers
{
    public class AutoMapperConfig
    {
        public static void RegisterMappings()
        {
            Mapper.CreateMap<TaskRunnerPropertyModel, PropertyWithValue>();
        }
    }
}