﻿using StructureMap;

namespace Business.Logic.Layer.Interfaces.Startup
{
    public interface IDependencyBootStrapper
    {
        IContainer ConfigureContainer();
    }
}