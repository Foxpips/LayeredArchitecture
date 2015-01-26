using System;
using System.Linq;

namespace TaskRunner.Core.Reflector
{
    public class DomainHelper
    {
        public static Type GetTypeFromAssembly(string typeName)
        {
            return AppDomain.CurrentDomain.GetAssemblies()
                .SelectMany(x => x.GetTypes())
                .FirstOrDefault(x => x.Name == typeName);
        } 
    }
}