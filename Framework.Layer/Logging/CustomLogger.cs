using System;
using System.IO;
using System.Reflection;
using System.Text;

using Framework.Layer.Logging.Resource;

using log4net;
using log4net.Appender;
using log4net.Config;
using log4net.Repository.Hierarchy;

namespace Framework.Layer.Logging
{
    public class CustomLogger
    {
        private readonly ILog _logger;

        public CustomLogger()
        {
            Configure();
            _logger = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
        }

        private static void Configure()
        {
            var buffer = Encoding.UTF8.GetBytes(ResourceLoader.Log4NetConfiguration());
            XmlConfigurator.Configure(new MemoryStream(buffer));
        }

        public
            void Log(Action<ILog> work)
        {
            work(_logger);
        }

        //TODO Simon move to new FileInspector class
        // ReSharper disable once UnusedMember.Local
        //This method can be used to inspect the settings defined for the file appender and check
        //if there are any issues with creating the log file or writing to it at runtime.
        private void Log4NetSettingsInspector()
        {
            foreach (var fileAppender in ((Hierarchy)LogManager.GetRepository()).Root.Appenders)
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