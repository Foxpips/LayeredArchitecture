using System;

using Business.Logic.Layer.Managers.ServiceBus;
using Business.Logic.Layer.Models.TaskRunner;

using Dependency.Resolver.Registries;

using NUnit.Framework;

using SqlAgentUIRunner.Controllers;

using StructureMap;
using StructureMap.Configuration.DSL;

namespace Tests.Integration.ScriptRunnerServiceTests.IoC
{
    public class ControllerInjectionTests
    {
        [Test]
        public void MethodUnderTest_TestedBehavior_ExpectedResult()
        {
            var container = new Container(new CardRegistry());

            var instance = container.GetInstance<Shopper>();

            instance.Card.ChargeCard();
        }

        [Test]
        public void TestReflect()
        {
            var container = new Container(new ReflectorRegistry());

            var reflector = container.GetInstance<IServiceBusMessageManager>();

            var taskRunnerMessagesModel = reflector.BuildMessagesModel();

            foreach (var message in taskRunnerMessagesModel.Messages)
            {
                Console.WriteLine(message);
            }
        }

        [Test]
        public void TestController_TestedBehavior_ExpectedResult()
        {
            var container = new Container(new ReflectorRegistry());

            var messageBusController = container.GetInstance<MessageBusController>();

            var jsonResult = messageBusController.GetMessages();
            var value = (jsonResult.Data as TaskRunnerMessagesModel);

            if (value != null)
            {
                foreach (var taskRunnerMessagesModel in value.Messages)
                {
                    Console.WriteLine(taskRunnerMessagesModel);
                }
            }
        }
    }

    public interface IShopper
    {
        ICreditCard Card { get; set; }
    }

    public class Shopper : IShopper
    {
        public ICreditCard Card { get; set; }

        public Shopper(ICreditCard card, string path)
        {
            Card = card;
        }
    }

    public interface ICreditCard
    {
        void ChargeCard();
    }

    public class MasterCard : ICreditCard
    {
        public string Output { get; set; }

        public MasterCard(string output)
        {
            Output = output;
        }

        public MasterCard(int a)
        {
        }

        public void ChargeCard()
        {
            Console.WriteLine(Output);
        }
    }

    public class CardRegistry : Registry
    {
        public CardRegistry()
        {
            For<ICreditCard>().Use<MasterCard>().Ctor<string>("output").Is("swiping the master card");
            For<Shopper>().Use<Shopper>().Ctor<string>("path").Is("hello");
        }
    }
}