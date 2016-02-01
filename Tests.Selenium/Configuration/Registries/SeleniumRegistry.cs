using Business.Logic.Layer.Helpers;
using Business.Objects.Layer.Interfaces.Execution;
using Business.Objects.Layer.Interfaces.Logging;
using Framework.Layer.Logging.LogTypes;
using StructureMap.Configuration.DSL;
using Tests.Selenium.Infrastructure.Managers;

namespace Tests.Selenium.Configuration.Registries
{
    public sealed class SeleniumRegistry : Registry
    {
        public SeleniumRegistry()
        {
            Scan(scan =>
            {
                For<ILoginManager>().Use<GmailLoginManager>();
                For<ICustomLogger>().Transient().Use(scope => new Log4NetFileLogger());
                For<IExecutionHandler>().Use<SafeExecutionHelper>();
            });
        }
    }
}