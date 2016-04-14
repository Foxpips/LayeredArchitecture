using System;
using System.Collections.Generic;
using System.Reflection;
using Business.Logic.Layer.Helpers;
using Business.Objects.Layer.Exceptions.Generic;
using Business.Objects.Layer.Exceptions.Generic.Args;
using Business.Objects.Layer.Interfaces.DataAccess;
using Business.Objects.Layer.Pocos.Sql;
using Data.Access.Layer.EntityDomain.Attributes;

namespace Data.Access.Layer.EntityDomain.Mappers
{
    public class SqlEntityMapper : IEntityMapper
    {
        public IEnumerable<SqlEntityProperty> MapTypeProperties<TType>(TType type)
        {
            var paramList = new List<SqlEntityProperty>();

            var objType = type.GetType();
            var properties = objType.GetProperties();

            foreach (var property in properties)
            {
                try
                {
                    var propertyValue = property.GetValue(type, null);
                    if (TypeCheckerHelper.IsNativeType(propertyValue))
                    {
                        paramList.Add(CreateSqlEntityProperty(property, propertyValue));
                    }
                    else
                    {
                        paramList.AddRange(MapTypeProperties(propertyValue));
                    }
                }
                catch (Exception)
                {
                    Console.WriteLine("Type not recognised!");
                    throw new CustomException<EntityMappingExceptionArgs>(
                        new EntityMappingExceptionArgs(property.Name));
                }
            }

            return paramList;
        }

        private static SqlEntityProperty CreateSqlEntityProperty(MemberInfo property, object propertyValue)
        {
            var propertyAttribute = property.GetCustomAttribute<DataParamAttribute>();
            var sqlEntityProperty = new SqlEntityProperty("@" + property.Name, propertyValue);

            if (propertyAttribute != null && propertyAttribute.IsOutput)
            {
                sqlEntityProperty.IsOutput = true;
            }
            return sqlEntityProperty;
        }
    }
}