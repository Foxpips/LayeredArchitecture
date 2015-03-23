using Business.Logic.Layer.Interfaces.Logging;

using Framework.Layer.Logging.LogTypes;

using StructureMap.Configuration.DSL;

namespace Dependency.Resolver.Registries
{
    public class LoggerRegistry : Registry
    {
        public LoggerRegistry()
        {
            Scan(scan => For<ICustomLogger>().Transient().Use(scope => new Log4NetFileLogger()));
        }
    }
}