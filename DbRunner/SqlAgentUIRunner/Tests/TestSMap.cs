using System;

using NUnit.Framework;

using SqlAgentUIRunner.Infrastructure.Manager;

using StructureMap.Configuration.DSL;

using TaskRunner.Core.Reflector;

using Container = StructureMap.Container;

namespace SqlAgentUIRunner.Tests
{
    public class TestSMap
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
//            Console.WriteLine(container.WhatDoIHave());

            var reflector = container.GetInstance<ServiceBusMessageManager>();

            var taskRunnerMessagesModel = reflector.BuildMessagesModel();

            foreach (var message in taskRunnerMessagesModel.Messages)
            {
                Console.WriteLine(message);
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
//            ObjectFactory.Container.Configure(x => x.Scan(scan =>
//            {
//                For<ICreditCard>().Use<MasterCard>().Ctor<string>("output").Is("swiping the master card");
//                For<IShopper>().Use<Shopper>().Ctor<string>("path").Is("hello");
//            }));
        }
    }

    public class ReflectorRegistry : Registry
    {
        public ReflectorRegistry()
        {
            For<IReflector>().Use<TaskRunnerReflector>();
            For<ServiceBusMessageManager>()
                .Use<ServiceBusMessageManager>()
                .Ctor<string>("path")
                .Is(
                    @"c:\Users\smarkey\Documents\GitHub\LayeredArchitecture\TaskRunner.Common\bin\Debug\TaskRunner.Common.dll");
        }
    }
}