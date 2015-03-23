﻿using System;

using Business.Logic.Layer.Interfaces.Logging;

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
    }
}