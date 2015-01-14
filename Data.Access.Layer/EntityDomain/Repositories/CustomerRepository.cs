using Business.Logic.Layer.Interfaces;

using Framework.Layer.Exceptions;
using Framework.Layer.Exceptions.Args;

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