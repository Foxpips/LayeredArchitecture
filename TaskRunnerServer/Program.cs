using System;
using System.IO;

using Service.Layer.ServiceBus;
using Service.Layer.ServiceBus.BootStrappers;

namespace TaskRunnerServer
{
    class Program
    {
        static void Main()
        {
//            File.WriteAllText(@"C:\Users\smarkey\Desktop\fileeee.txt", "testestestestestestest");
            ServiceBusServer.Start<TaskRunnerBootStrapper>();
            Console.Read();
        }
    }
}
