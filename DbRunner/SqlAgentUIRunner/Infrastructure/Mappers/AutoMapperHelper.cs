using System;
using System.Collections.Generic;
using System.Linq;

using AutoMapper;

namespace SqlAgentUIRunner.Infrastructure.Mappers
{
    public class AutoMapperHelper
    {
        public static void LoadAllMappings(IEnumerable<Type> types)
        {
            var enumerable = types.ToList();
            LoadStandardMappings(enumerable);
            LoadCustomMappings(enumerable);
        }

        public static void LoadCustomMappings(IEnumerable<Type> types)
        {
            foreach (var type in types.Where(
                type => typeof (IMapCustom).IsAssignableFrom(type) && !type.IsInterface && !type.IsAbstract))
            {
                ((IMapCustom) Activator.CreateInstance(type)).CreateMappings(Mapper.Configuration);
            }
        }

        public static void LoadStandardMappings(IEnumerable<Type> types)
        {
            foreach (var exportedType in types)
            {
                var imapInterface = exportedType.GetInterfaces();
                var type = exportedType;
                foreach (var maps in imapInterface.Where(
                    interfaceImplemented =>
                        interfaceImplemented.IsGenericType && typeof (IMapFrom).IsAssignableFrom(type))
                    .Select(mapping => new {Source = mapping.GetGenericArguments(), Dest = type}))
                {
                    foreach (var mappableType in maps.Source)
                    {
                        Mapper.CreateMap(mappableType, maps.Dest);
                    }
                }
            }
        }
    }
}