using StructureMap;

namespace Core.Library.IOC
{
    public class CustomContainer : IRunAtStartup
    {
        public CustomContainer()
        {
//            ObjectFactory.Initialize(x => x.AddRegistry(new LoggerRegistry()));
        }
    }

    public interface IRunAtStartup
    {
    }
}