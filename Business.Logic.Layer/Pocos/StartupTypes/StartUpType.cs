using Business.Logic.Layer.Interfaces.Logging;
using Business.Logic.Layer.Interfaces.Startup;

using StructureMap;

namespace Business.Logic.Layer.Pocos.StartupTypes
{
    public class StartUpType : IRunAtStartup
    {
        private readonly IContainer _container;

        public StartUpType(IContainer dependency)
        {
            _container = dependency;
        }

        public void Execute()
        {
            var customLogger = _container.GetInstance<ICustomLogger>();

            customLogger.Info("Executing on startup!");
        }
    }
}