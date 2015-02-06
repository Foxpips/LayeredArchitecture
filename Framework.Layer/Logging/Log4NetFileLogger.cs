using System;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text;

using Framework.Layer.Logging.Resource;

using log4net;
using log4net.Appender;
using log4net.Config;

namespace Framework.Layer.Logging
{
    public class Log4NetFileLogger : IMessageLogger
    {
        private ILog Logger { get; set; }

        public Log4NetFileLogger()
        {
            Configure();
            Logger = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
        }

        public Log4NetFileLogger(Type targetType, string outputPath = "")
        {
            Configure();
            Logger = LogManager.GetLogger(targetType);

            if (!string.IsNullOrEmpty(outputPath))
            {
                SetOutputPath(outputPath);
            }
        }

        private static void Configure()
        {
            XmlConfigurator.Configure(new MemoryStream(Encoding.UTF8.GetBytes(ResourceLoader.Log4NetConfiguration())));
        }

        private static void SetOutputPath(string outputPath)
        {
            var appender = LogManager.GetRepository().GetAppenders().First(x => x is RollingFileAppender);
            var fileAppender = ((FileAppender) appender);
            fileAppender.File = outputPath;
            fileAppender.ActivateOptions();
        }

        public void Info(object message)
        {
            Logger.Info(message);
        }

        public void Debug(object message)
        {
            Logger.Debug(message);
        }

        public void Error(object message)
        {
            Logger.Error(message);
        }

        public void Fatal(object message)
        {
            Logger.Fatal(message);
        }

        public void Warn(object message)
        {
            Logger.Warn(message);
        }
    }
}