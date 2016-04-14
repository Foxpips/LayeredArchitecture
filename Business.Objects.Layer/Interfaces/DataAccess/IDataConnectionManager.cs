using System.Collections.Generic;
using Business.Objects.Layer.Pocos.Sql;

namespace Business.Objects.Layer.Interfaces.DataAccess
{
    public interface IDataConnectionManager
    {
        IEntity Persist(IEntity entity, string sprocName, IEnumerable<SqlEntityProperty> entityProperties);
    }
}