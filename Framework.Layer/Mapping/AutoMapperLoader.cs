using System;
using System.Collections.Generic;
using System.Linq;

using AutoMapper;

namespace Framework.Layer.Mapping
{
    public class AutoMapperLoader
    {
        public static void LoadAllMappings(IEnumerable<Type> types)
        {
            var typesList = types.ToList();
            LoadMapFromMappings(typesList, CreateMapFromMappings);
            LoadMapFromMappings(typesList, CreateMapToMappings);
            LoadCustomMappings(typesList);
        }

        private static void LoadCustomMappings(IEnumerable<Type> types)
        {
            foreach (
                var type in
                    types.Where(
                        type => typeof (IMapCustom).IsAssignableFrom(type) && !type.IsInterface && !type.IsAbstract))
            {
                ((IMapCustom) Activator.CreateInstance(type)).CreateMappings(Mapper.Configuration);
            }
        }

        private static void LoadMapFromMappings(IEnumerable<Type> types, Action<Type[], Type> createMappings)
        {
            foreach (var exportedType in types)
            {
                var imapInterface = exportedType.GetInterfaces();
                var type = exportedType;
                createMappings(imapInterface, type);
            }
        }

        private static void CreateMapFromMappings(IEnumerable<Type> imapInterface, Type type)
        {
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

        private static void CreateMapToMappings(IEnumerable<Type> imapInterface, Type type)
        {
            foreach (var maps in imapInterface.Where(
                interfaceImplemented =>
                    interfaceImplemented.IsGenericType && typeof (IMapFrom).IsAssignableFrom(type))
                .Select(mapping => new {Source = mapping.GetGenericArguments(), Dest = type}))
            {
                foreach (var mappableType in maps.Source)
                {
                    Mapper.CreateMap(maps.Dest, mappableType);
                }
            }
        }
    }
}