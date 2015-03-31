using System;
using System.Linq;

namespace Business.Logic.Layer.Helpers
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