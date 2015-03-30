using System;
using System.Collections.Generic;

namespace Business.Logic.Layer.Interfaces.Reflection
{
    public interface IReflector
    {
        IEnumerable<Type> GetTypesFromDll(string assemblyPath);
        Type GetMessageType(string typeName);
    }
}