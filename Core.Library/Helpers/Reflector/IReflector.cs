using System;
using System.Collections.Generic;

using Core.Library.Extensions;

namespace Core.Library.Helpers.Reflector
{
    public interface IReflector
    {
        IEnumerable<Type> GetTypesFromDll(string assemblyPath);
        Type GetMessageType(string typeName);
        void SendMessage(Type messageType, PropertyWithValue[] props = null);
    }
}