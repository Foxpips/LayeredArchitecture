using Business.Logic.Layer.Interfaces.Logging;

using Framework.Layer.Logging;

using StructureMap.Configuration.DSL;

namespace TaskRunner.Common.Registries
{
    public class LoggerRegistry : Registry
    {
        public LoggerRegistry()
        {
            Scan(scan => For<ICustomLogger>().Transient().Use(scope => new Log4NetFileLogger()));
        }
    }
}