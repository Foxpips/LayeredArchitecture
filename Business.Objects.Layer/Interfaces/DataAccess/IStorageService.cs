namespace Business.Objects.Layer.Interfaces.DataAccess
{
    public interface IStorageService
    {
        TEntity StoreEntity<TEntity>(TEntity entity) where TEntity : IEntity;
        TEntity RetrieveEntity<TEntity>() where TEntity : IEntity;
    }
}