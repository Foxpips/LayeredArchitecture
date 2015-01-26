using System.Reflection;

namespace TaskRunner.Core.Reflector
{
    public static class Extensions
    {
        public static PropertyInfo[] GetPublicProperties(this IReflect type)
        {
            return type.GetProperties(BindingFlags.CreateInstance | BindingFlags.Public);
        }
    }
}