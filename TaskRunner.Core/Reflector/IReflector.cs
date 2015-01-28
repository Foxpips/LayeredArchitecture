using System;
using System.Collections.Generic;

using Core.Library.Extensions;

namespace TaskRunner.Core.Reflector
{
    public interface IReflector
    {
        IEnumerable<Type> GetTypesFromDll(string assemblyPath);
        Type GetMessageType(string typeName);
        void SendMessage(Type messageType, PropertyWithValue[] props = null);
    }
}