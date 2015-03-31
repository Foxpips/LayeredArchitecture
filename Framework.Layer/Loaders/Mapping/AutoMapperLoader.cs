using System;
using System.Collections.Generic;
using System.Linq;

using AutoMapper;

using Business.Objects.Layer.Interfaces.AutoMapper;

namespace Framework.Layer.Loaders.Mapping
{
    public class AutoMapperLoader
    {
        public static void LoadAllMappings(IEnumerable<Type> types)
        {
            var typesList = types.ToList();

            LoadToFromMappings(typesList);
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

        private static void LoadToFromMappings(IEnumerable<Type> types)
        {
            foreach (var exportedType in types)
            {
                var imapInterfaces = exportedType.GetInterfaces();

                CreateMappings<IMapTo>(imapInterfaces, exportedType,
                    (genericType, baseType) => Mapper.CreateMap(baseType, genericType));

                CreateMappings<IMapFrom>(imapInterfaces, exportedType,
                    (genericType, baseType) => Mapper.CreateMap(genericType, baseType));
            }
        }

        private static void CreateMappings<TMapType>(
            IEnumerable<Type> imapInterfaces, Type type, Action<Type, Type> map)
        {
            var enumerable =
                imapInterfaces.Where(
                    interfaceImplemented =>
                        interfaceImplemented.IsGenericType && typeof (TMapType).IsAssignableFrom(type) &&
                        interfaceImplemented.Name.Contains(typeof (TMapType).Name));

            foreach (var maps in 
                enumerable.Select(mapping => new {GenericTypes = mapping.GetGenericArguments(), BaseType = type}))
            {
                foreach (var genericType in maps.GenericTypes)
                {
                    map(genericType, maps.BaseType);
                    Mapper.AssertConfigurationIsValid();
                }
            }
        }
    }
}