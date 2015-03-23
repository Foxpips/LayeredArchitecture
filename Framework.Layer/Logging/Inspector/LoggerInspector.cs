using System;
using System.IO;

using log4net;
using log4net.Appender;
using log4net.Repository.Hierarchy;

namespace Framework.Layer.Logging.Inspector
{
    public class LoggerInspector
    {
//        This method can be used to inspect the settings defined for the file appender and check
//        if there are any issues with creating the log file or writing to it at runtime.
        public void Log4NetSettingsInspector()
        {
            foreach (var fileAppender in ((Hierarchy) LogManager.GetRepository()).Root.Appenders)
            {
                var appender = fileAppender as FileAppender;
                if (appender != null)
                {
                    Console.WriteLine(appender.File);

                    if (!File.Exists(appender.File))
                    {
                        using (var fileStream = File.CreateText(appender.File))
                        {
                            fileStream.Write("TESTING THIS FILE");
                        }
                    }
                }
            }
        }
    }
}