using Business.Logic.Layer.Exceptions.Generic;
using Business.Logic.Layer.Exceptions.Generic.Args;

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