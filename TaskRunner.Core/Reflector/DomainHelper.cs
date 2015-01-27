using System;
using System.Linq;

namespace TaskRunner.Core.Reflector
{
    internal class DomainHelper
    {
        public static Type GetTypeFromAssembly(string typeName)
        {
            return AppDomain.CurrentDomain.GetAssemblies()
                .SelectMany(x => x.GetTypes())
                .FirstOrDefault(x => x.Name == typeName);
        } 
    }
}