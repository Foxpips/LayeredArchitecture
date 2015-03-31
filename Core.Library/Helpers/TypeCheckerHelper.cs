using System.Linq;

namespace Business.Logic.Layer.Helpers
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