using System.Collections.Generic;
using Business.Objects.Layer.Pocos.Sql;

namespace Business.Objects.Layer.Interfaces.DataAccess
{
    public interface IEntityMapper
    {
        IEnumerable<SqlEntityProperty> MapTypeProperties<TType>(TType type);
    }
}