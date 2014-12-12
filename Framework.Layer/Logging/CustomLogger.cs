using System;
using System.IO;
using System.Reflection;
using System.Text;

using Framework.Layer.Logging.Resource;

using log4net;
using log4net.Config;

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

        public void Log(Action<ILog> work)
        {
            work(_logger);
        }
    }
}