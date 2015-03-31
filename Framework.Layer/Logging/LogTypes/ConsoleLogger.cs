using System;

using Business.Objects.Layer.Interfaces.Logging;

namespace Framework.Layer.Logging.LogTypes
{
    public class ConsoleLogger : ICustomLogger
    {
        public void Info(object message)
        {
            Console.WriteLine(message);
        }

        public void Debug(object message)
        {
#if DEBUG
            Console.WriteLine(message);
#endif
        }

        public void Error(object message)
        {
            Console.WriteLine("Error: " + message);
        }

        public void Fatal(object message)
        {
            Console.WriteLine("Fatal: " + message);
        }

        public void Warn(object message)
        {
            Console.WriteLine("Warning: " + message);
        }

        public void ErrorFormat(string format, params object[] args)
        {
            Console.WriteLine("Warning:{0} ", args[0]);
        }

        public void Dispose()
        {
            Console.WriteLine("Calling dispose on logger");
        }
    }
}