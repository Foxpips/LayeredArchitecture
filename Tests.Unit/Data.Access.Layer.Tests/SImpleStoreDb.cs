using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using Business.Logic.Layer.Extensions;
using Business.Logic.Layer.Helpers;
using Framework.Layer.Logging.LogTypes;
using NUnit.Framework;

namespace Tests.Unit.Data.Access.Layer.Tests
{
    public interface IRepository<in TModel> where TModel : IModel
    {
        void Persist(TModel model);
        TModelType Retrieve<TModelType>() where TModelType : new();
    }

    public interface IStorageService
    {
        void Persist<TEntity>(TEntity customerEntity) where TEntity : IEntity;
        TEntity Retrieve<TEntity>() where TEntity : IEntity;
        List<TEntity> RetrieveCollection<TEntity>() where TEntity : IEntity;
    }

    public interface IModel
    {
    }

    public interface IEntity
    {
    }

    public interface ICustomerEntity : IEntity
    {
    }

    [Description("CustomerTable")]
    public class CustomerEntity : ICustomerEntity
    {
        public string Name { get; set; }
    }

    public interface ICustomerModel : IModel
    {
        string Name { get; set; }
    }


    public class BronzeCustomer : ICustomerModel
    {
        public string Name { get; set; }
    }

    public interface IDomainEntityMapper
    {
        TEntity MapToEntity<TModel, TEntity>(IModel model)
            where TEntity : new()
            where TModel : IModel;

        TModel MapFromEntity<TEntity, TModel>(IEntity customerEntity)
            where TEntity : IEntity
            where TModel : new();
    }

    public class DomainEntityMapper : IDomainEntityMapper
    {
        public TEntity MapToEntity<TModel, TEntity>(IModel model)
            where TEntity : new()
            where TModel : IModel
        {
            var entity = new TEntity();
            entity.SetPropertyInfos(model, model.GetType().GetProperties());
            return entity;
        }

        public TModel MapFromEntity<TEntity, TModel>(IEntity entity)
            where TEntity : IEntity
            where TModel : new()
        {
            var model = new TModel();
            model.SetPropertyInfos(entity, entity.GetType().GetProperties());
            return model;
        }
    }

    public class JsonStorageService : IStorageService
    {
        private readonly JsonHelper _jsonHelper;
        private const string Path = @"C:\\users\\SimonMarkey\Desktop\\{0}.txt";

        public JsonStorageService()
        {
            _jsonHelper = new JsonHelper(new ConsoleLogger());
        }

        public void Persist<TEntity>(TEntity entity) where TEntity : IEntity
        {
            var decription = entity.GetType().GetCustomAttribute<DescriptionAttribute>();
            _jsonHelper.PersistJsonObject(entity, string.Format(Path, decription.Description));
        }

        public TEntity Retrieve<TEntity>() where TEntity : IEntity
        {
            var decription = typeof (TEntity).GetCustomAttribute<DescriptionAttribute>();
            return
                _jsonHelper.RetrieveJsonCollection<TEntity>(string.Format(Path, decription.Description)).FirstOrDefault();
        }

        public List<TEntity> RetrieveCollection<TEntity>() where TEntity : IEntity
        {
            var decription = typeof (TEntity).GetCustomAttribute<DescriptionAttribute>();
            return _jsonHelper.RetrieveJsonCollection<TEntity>(string.Format(Path, decription.Description)).ToList();
        }
    }

    public class CustomerRepository : IRepository<ICustomerModel>
    {
        protected IStorageService Service { get; set; }
        protected IDomainEntityMapper Mapper { get; set; }

        public CustomerRepository(IStorageService service, IDomainEntityMapper mapper)
        {
            Service = service;
            Mapper = mapper;
        }

        public void Persist(ICustomerModel model)
        {
            var mapToEntity = Mapper.MapToEntity<ICustomerModel, CustomerEntity>(model);
            Service.Persist(mapToEntity);
        }

        public TCustomerModel Retrieve<TCustomerModel>() where TCustomerModel : new()
        {
            var customerEntity = Service.Retrieve<CustomerEntity>();
            return Mapper.MapFromEntity<ICustomerEntity, TCustomerModel>(customerEntity);
        }

        public IEnumerable<TCustomerModel> GetTable<TCustomerModel>() where TCustomerModel : new()
        {
            var customerEntity = Service.RetrieveCollection<CustomerEntity>();
            return customerEntity.Select(entity => Mapper.MapFromEntity<ICustomerEntity, TCustomerModel>(entity));
        }
    }

    public class TestStores
    {
        [Test]
        public void Method_Scenario_Result()
        {
            var storageService = new JsonStorageService();
            var entMap = new DomainEntityMapper();

            var customerRepository = new CustomerRepository(storageService, entMap);
            customerRepository.Persist(new BronzeCustomer {Name = "Simon"});
            customerRepository.Persist(new BronzeCustomer {Name = "Val"});

            var customerTable = customerRepository.GetTable<BronzeCustomer>();
            foreach (var bronzeCustomer in customerTable)
            {
                Console.WriteLine(bronzeCustomer.Name);
            }
        }
    }
}