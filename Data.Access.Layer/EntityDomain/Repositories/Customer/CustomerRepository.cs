using Business.Objects.Layer.Exceptions.Generic;
using Business.Objects.Layer.Exceptions.Generic.Args;
using Business.Objects.Layer.Interfaces.DataAccess;

namespace Data.Access.Layer.EntityDomain.Repositories.Customer
{
    internal class CustomerRepository : IRepository<ICustomerEntity>
    {
        private IStorageService StorageService { get; set; }

        public CustomerRepository(IStorageService service)
        {
            StorageService = service;
        }
        
        public void Save<TEntity>(TEntity entity) where TEntity : ICustomerEntity
        {
            try
            {
                StorageService.StoreEntity(entity);
            }
            catch (CustomException<EntityMappingExceptionArgs> ex)
            {
                ex.Args.Handle();
                throw;
            }
        }
    }
}