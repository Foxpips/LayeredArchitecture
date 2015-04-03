using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;

using Business.Objects.Layer.Interfaces.Reflection;

namespace Business.Logic.Layer.Helpers.Reflector
{
    public class TaskRunnerReflector : IReflector
    {
        public IEnumerable<Type> GetTypesFromDll(string assemblyPath)
        {
            var assembly = Assembly.LoadFile(assemblyPath);

            return assembly.GetExportedTypes().Where(x =>
                x.Name.EndsWith("Event", StringComparison.OrdinalIgnoreCase) ||
                x.Name.EndsWith("Command", StringComparison.OrdinalIgnoreCase));
        }

        public Type GetMessageType(string typeName)
        {
            return DomainHelper.GetTypeFromAssembly(typeName);
        }
    }
}