using System.Linq;

namespace Core.Library.Helpers
{
    public class TypeCheckerHelper
    {
        public static bool IsNativeType(object obj)
        {
            var assembly = typeof (object).Assembly;
            return assembly.GetExportedTypes().Contains(obj.GetType());
        }
    }
}