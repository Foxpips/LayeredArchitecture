using System.Reflection;
using Business.Objects.Layer.Interfaces.DataAccess;
using Data.Access.Layer.EntityDomain.Attributes;

namespace Data.Access.Layer.EntityDomain.Services
{
    public class EntityStorageService : IStorageService
    {
        private readonly IEntityMapper _mapper;
        private readonly IDataConnectionManager _manager;

        public EntityStorageService(IEntityMapper mapper, IDataConnectionManager manager)
        {
            _manager = manager;
            _mapper = mapper;
        }

        public TEntity StoreEntity<TEntity>(TEntity entity) where TEntity : IEntity
        {
            var entityProperties = _mapper.MapTypeProperties(entity);
            var sprocName = entity.GetType().GetCustomAttribute<SprocNameAttribute>().SprocName;
            return (TEntity) _manager.Persist(entity, sprocName, entityProperties);
        }

        public TEntity RetrieveEntity<TEntity>() where TEntity : IEntity
        {
            return default(TEntity);
        }
    }
}