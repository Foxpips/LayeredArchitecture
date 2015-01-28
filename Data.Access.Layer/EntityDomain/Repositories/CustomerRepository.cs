using Business.Logic.Layer.Interfaces;

using Core.Library.Exceptions;
using Core.Library.Exceptions.Generic;
using Core.Library.Exceptions.Generic.Args;

namespace Data.Access.Layer.EntityDomain.Repositories
{
    internal class CustomerRepository : RepositoryBase
    {
        public static void Save<TEntity>(TEntity entity) where TEntity : IEntity
        {
            try
            {
                SaveEntity(entity);
            }
            catch (CustomException<EntityMappingExceptionArgs> ex)
            {
                ex.Args.Handle();
                throw;
            }
        }
    }
}