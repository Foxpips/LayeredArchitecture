using System;
using System.Data;

namespace Business.Objects.Layer.Bases.DataAccess
{
    public abstract class DataConnectionBase
    {
        protected string ConnectionString;

        protected DataConnectionBase(string connectionString)
        {
            ConnectionString = connectionString;
        }

        public void Connect<TConnType>(string connString, Action<TConnType, IDbCommand> work)
            where TConnType : class, IDbConnection, new()
        {
            using (var connType = new TConnType { ConnectionString = connString })
            {
                using (var dbCommand = connType.CreateCommand())
                {
                    connType.Open();
                    work(connType, dbCommand);
                    connType.Close();
                }
            }
        }
    }
}