using System;
using System.Collections.Generic;

using Business.Objects.Layer.Pocos.Reflection;

namespace Business.Objects.Layer.Interfaces.Reflection
{
    public interface IReflector
    {
        IEnumerable<Type> GetTypesFromDll(string assemblyPath);
        Type GetMessageType(string typeName);
        void SendMessage(Type messageType, PropertyWithValue[] props = null);
    }
}