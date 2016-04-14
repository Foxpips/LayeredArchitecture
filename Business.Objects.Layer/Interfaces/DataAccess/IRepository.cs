namespace Business.Objects.Layer.Interfaces.DataAccess
{
    public interface IRepository<in TEntityType>
    {
        void Save<TEntity>(TEntity entity) where TEntity : TEntityType;
    }
}