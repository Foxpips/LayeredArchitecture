using Rhino.ServiceBus.StructureMap;

using StructureMap.Configuration.DSL;

namespace TaskRunner.Core.BootStrappers
{
    public class CustomBootStrapper<TType> : StructureMapBootStrapper where TType : Registry, new()
    {
        protected override void ConfigureContainer()
        {
            base.ConfigureContainer();
            Container.Configure(cfg => cfg.AddRegistry<TType>());
        }
    }

    public class CustomBootStrapper<TType, TType2> : StructureMapBootStrapper where TType : Registry, new()
        where TType2 : Registry, new()
    {
        protected override void ConfigureContainer()
        {
            base.ConfigureContainer();
            Container.Configure(cfg =>
            {
                cfg.AddRegistry<TType>();
                cfg.AddRegistry<TType2>();
            });
        }
    }

    public class CustomBootStrapper<TType, TType2, TType3> : StructureMapBootStrapper where TType : Registry, new()
        where TType3 : Registry, new()
        where TType2 : Registry, new()
    {
        protected override void ConfigureContainer()
        {
            base.ConfigureContainer();
            Container.Configure(cfg =>
            {
                cfg.AddRegistry<TType>();
                cfg.AddRegistry<TType2>();
                cfg.AddRegistry<TType3>();
            });
        }
    }

    public class CustomBootStrapper<TType, TType2, TType3, TType4> : StructureMapBootStrapper
        where TType : Registry, new()
        where TType4 : Registry, new()
        where TType2 : Registry, new()
        where TType3 : Registry, new()
    {
        protected override void ConfigureContainer()
        {
            base.ConfigureContainer();
            Container.Configure(cfg =>
            {
                cfg.AddRegistry<TType>();
                cfg.AddRegistry<TType2>();
                cfg.AddRegistry<TType3>();
                cfg.AddRegistry<TType4>();
            });
        }
    }
}