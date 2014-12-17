using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Reflection;

using Business.Logic.Layer.Interfaces;

using Core.Library.Helpers;

using Data.Access.Layer.EntityDomain.Attributes;

using Framework.Layer.Exceptions;
using Framework.Layer.Exceptions.Args;

namespace Data.Access.Layer.EntityDomain.Repositories
{
    public abstract class RepositoryBase
    {
        protected static TEntity SaveEntity<TEntity>(TEntity entity) where TEntity : IEntity
        {
            var entityProperties = MapTypeProperties(entity);
            var sprocName = entity.GetType().GetCustomAttribute<SprocNameAttribute>().SprocName;
            return (TEntity) StoreEntityInDb(entity, sprocName, entityProperties);
        }

        protected static TEntity GetEntity<TEntity>() where TEntity : IEntity
        {
            var type = typeof (TEntity);
            return default(TEntity);
        }

        private static IEnumerable<SqlEntityProperty> MapTypeProperties<TType>(TType type)
        {
            var paramList = new List<SqlEntityProperty>();

            var objType = type.GetType();
            var properties = objType.GetProperties();

            foreach (var property in properties)
            {
                try
                {
                    var propertyValue = property.GetValue(type, null);
                    if (TypeChecker.IsNativeType(propertyValue))
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

        private static IEntity StoreEntityInDb(
            IEntity entity, string sprocName, IEnumerable<SqlEntityProperty> entityProperties)
        {
            using (var conn = new SqlConnection(ConfigurationManager.AppSettings["SqlSprintConnect"]))
            {
                using (var com = conn.CreateCommand())
                {
                    com.CommandType = CommandType.StoredProcedure;
                    com.CommandText = sprocName;

                    foreach (var property in entityProperties)
                    {
                        if (property.IsOutput)
                        {
                            var sqlParameter = new SqlParameter
                            {
                                ParameterName = property.Name,
                                DbType = (DbType) Enum.Parse(typeof (DbType), property.Value.GetType().Name, true),
                                Direction = ParameterDirection.Output,
                                Value = property.Value
                            };
                            com.Parameters.Add(sqlParameter);
                        }
                        else
                        {
                            com.Parameters.AddWithValue(property.Name, property.Value);
                        }
                    }

                    conn.Open();
                    com.ExecuteNonQuery();
                    UpdateEntityState(com.Parameters, entity);
                }
            }
            return entity;
        }

        private static void UpdateEntityState(IEnumerable paramList, IEntity entity)
        {
            var parameters = paramList.Cast<SqlParameter>().ToList();
            var entityOutputProperties =
                entity.GetType().GetProperties().Where(x => x.GetCustomAttribute<DataParamAttribute>() != null);

            foreach (var property in entityOutputProperties)
            {
                var outputValue = parameters.Single(x => x.ParameterName.Substring(1) == property.Name).Value;
                property.SetValue(entity, outputValue, null);
            }
        }

        private class SqlEntityProperty
        {
            public bool IsOutput { get; set; }
            public string Name { get; private set; }
            public object Value { get; private set; }

            public SqlEntityProperty(string name, object value)
            {
                Value = value;
                Name = name;
            }

            public override string ToString()
            {
                return String.Format("{0} - {1}", Name, Value);
            }
        }
    }
}