using System;
using System.Collections.Generic;
using System.IO;
using System.Runtime.Serialization;
using System.Runtime.Serialization.Formatters.Soap;

using NUnit.Framework;

namespace Tests.Library.Misc
{
    public class TestClass : IDisposable
    {
        public TestClass()
        {
            Console.WriteLine("Instantiating Object");
        }

        public void WriteMessage()
        {
            Console.WriteLine("HelloWorld");
        }

        public void Dispose()
        {
            Console.WriteLine("Disposing");
        }
    }

    public class TestDispose
    {
        [Test]
        public void MethodUnderTest_TestedBehavior_ExpectedResult()
        {
            using (var testClass = new TestClass())
            {
                testClass.WriteMessage();
            }

            var testClass2 = new TestClass();
            try
            {
                testClass2.WriteMessage();
            }
            finally
            {
                testClass2.Dispose();
            }
        }

        [Test]
        public void MethodUnderTest_TestedBehavior_Serialize()
        {
            var obj = new MyObject {_n1 = 1, _n2 = 24, _str = "Some String"};
            IFormatter formatter = new SoapFormatter();

            using (
                Stream stream = new FileStream(@"C:\Users\smarkey\Desktop\MyFile.xml", FileMode.Create, FileAccess.Write,
                    FileShare.None))
            {
                formatter.Serialize(stream, obj);
            }
        }

        [Test]
        public void MethodUnderTest_TestedBehavior_Deserialize()
        {
            IFormatter formatter = new SoapFormatter();
            Stream stream = new FileStream(@"C:\Users\smarkey\Desktop\MyFile.xml", FileMode.Open, FileAccess.Read,
                FileShare.Read);
            var obj = (MyObject) formatter.Deserialize(stream);
            stream.Close();

            // Here's the proof.
            Console.WriteLine("n1: {0}", obj._n1);
            Console.WriteLine("n2: {0}", obj._n2);
            Console.WriteLine("str: {0}", obj._str);
        }
    }

    public class TestInstance
    {
        public static string Name { get; set; }
        public static readonly string GetStuff;
        public static readonly List<string> GetStuffList = new List<string>();

        public TestInstance()
        {
            Name = "Test";
//            GetStuff = "stuff";
//            GetStuffList = new List<string>();
            GetStuffList.Add("hey");
        }
    }

    public static class TestStatics
    {
        public static string Name { get; set; }
        public static readonly string GetStuff;
        public static readonly List<string> GetStuffList;

        static TestStatics()
        {
            Name = "Johnjo";
            GetStuff = "Awesome";
            GetStuffList = new List<string>();
        }

        public static void GetSomeStuff()
        {
//            GetStuff = "test";
        }
    }
}