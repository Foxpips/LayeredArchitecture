using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

using Buy4Now.Three.Database;

using NUnit.Framework;

using Rhino.ServiceBus;
using Rhino.ServiceBus.Impl;

using StructureMap;

using TaskRunner.Common.Messages;
using TaskRunner.Common.Messages.Arvato;

namespace IntegrationTests
{
    [TestFixture]
    public class TaskRunnerTests
    {
        [TestFixtureSetUp]
        public void TestFixtureSetUp()
        {
            new OnewayRhinoServiceBusConfiguration()
                .UseStructureMap(ObjectFactory.Container)
                .Configure();
        }

        [Test]
        [Ignore]
        public void Publish_OrderDispatchedMessage()
        {
            var bus = ObjectFactory.GetInstance<IOnewayBus>();
//            bus.Send(new OrderDispatchedEvent(44443));
            bus.Send(new OrderDispatchedEvent(90467));
        }

        [Test]
        [Ignore]
        public void Publish_PierCaseAddedMessage()
        {
            var bus = ObjectFactory.GetInstance<IOnewayBus>();
//            bus.Send(new AddPierResponseToDatabaseCommand(85626, 101, DateTime.Now, 11, DateTime.Now));
//            bus.Send(new OrderDispatchedEvent(85392));
        }

        [Test]
        [Ignore]
        public void Publish_CreateArvatoBatchCommand()
        {
            var bus = ObjectFactory.GetInstance<IOnewayBus>();
            bus.Send(new CreateArvatoBatchCommand());
        }

        [Test]
        [Ignore]
        public void GenerateArvatoBatchFileForBatch()
        {
            var bus = ObjectFactory.GetInstance<IOnewayBus>();
            bus.Send(new ArvatoBatchCreatedEvent(10294));
        }

        [Test]
        public void ImportOutOfStockOrders()
        {
            var bus = ObjectFactory.GetInstance<IOnewayBus>();
            bus.Send(new ImportOutOfStockOrdersFileCommand());
        }

        [Test]
        public void ImportFinalisedOrders()
        {
            var bus = ObjectFactory.GetInstance<IOnewayBus>();
            bus.Send(new ImportFinalisedOrdersFileCommand());
        }

        [Test]
        [Ignore]
        public void GenerateArvatoBatchFileForAllBatches()
        {
            string connectionString = "server=sth3gisql;database=H3GI;uid=b4nuser;pwd=telex12;app=3TaskRunner";
//            string connectionString = "server=uat3sql;database=H3GI;uid=b4nuser;pwd=telex12;app=3TaskRunner";

            var batchIds = new List<int>();

            using (var connection = new SqlConnection(connectionString))
            {
                using (SqlCommand command = connection.CreateCommand())
                {
                    command.CommandType = CommandType.Text;
                    command.CommandText = "SELECT BatchID FROM h3giBatch";

                    connection.Open();

                    using (var reader = new SafeDataReader(command.ExecuteReader()))
                    {
                        while (reader.Read())
                        {
                            batchIds.Add(reader.GetInt32("BatchID"));
                        }
                    }
                }
            }

            var bus = ObjectFactory.GetInstance<IOnewayBus>();
            foreach (int batchId in batchIds)
            {
                bus.Send(new ArvatoBatchCreatedEvent(batchId));
            }
        }
    }
}