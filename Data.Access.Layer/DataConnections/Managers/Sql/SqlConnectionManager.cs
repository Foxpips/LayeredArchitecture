using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Reflection;
using Business.Objects.Layer.Bases.DataAccess;
using Business.Objects.Layer.Interfaces.DataAccess;
using Business.Objects.Layer.Pocos.Sql;
using Data.Access.Layer.EntityDomain.Attributes;

namespace Data.Access.Layer.DataConnections.Managers.Sql
{
    public class SqlConnectionManager : DataConnectionBase, IDataConnectionManager
    {
        public SqlConnectionManager(string connectionString)
            : base(connectionString)
        {
//ConfigurationManager.AppSettings["SqlSprintConnect"]
        }

        public IEntity Persist(IEntity entity, string sprocName, IEnumerable<SqlEntityProperty> entityProperties)
        {
            Connect<SqlConnection>(ConnectionString, (conn, command) =>
            {
                command.CommandType = CommandType.StoredProcedure;
                command.CommandText = sprocName;

                foreach (var property in entityProperties)
                {
                    if (property.IsOutput)
                    {
                        var sqlParameter = new SqlParameter
                        {
                            ParameterName = property.Name,
                            DbType = (DbType)Enum.Parse(typeof(DbType), property.Value.GetType().Name, true),
                            Direction = ParameterDirection.Output,
                            Value = property.Value
                        };
                        command.Parameters.Add(sqlParameter);
                    }
                    else
                    {
                        ((SqlCommand)command).Parameters.AddWithValue(property.Name, property.Value);
                    }
                }

                command.ExecuteNonQuery();
                Update(command.Parameters, entity);
            });

            return entity;
        }

        private static void Update(IEnumerable paramList, IEntity entity)
        {
            var parameters = paramList.Cast<SqlParameter>().ToList();
            var entityOutputProperties = entity.GetType().GetProperties().Where(x => x.GetCustomAttribute<DataParamAttribute>() != null);

            foreach (var property in entityOutputProperties)
            {
                var outputValue = parameters.Single(x => x.ParameterName.Substring(1) == property.Name).Value;
                property.SetValue(entity, outputValue, null);
            }
        }
    }
}