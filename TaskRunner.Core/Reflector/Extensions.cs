using System;
using System.Linq;
using System.Reflection;

namespace TaskRunner.Core.Reflector
{
    public static class Extensions
    {
        public static PropertyInfo[] GetPublicProperties(this IReflect type)
        {
            return type.GetProperties(BindingFlags.CreateInstance | BindingFlags.Public);
        }

        public static void SetPublicProperties(this object instance, PropertyWithValue[] props)
        {
            var propertyInfos = instance.GetType().GetProperties();
            foreach (var propertyInfo in propertyInfos)
            {
                var info = propertyInfo;
                foreach (var prop in props.Where(prop => info.Name.Equals(prop.Name)))
                {
                    var convertedValue = Convert.ChangeType(prop.Value, propertyInfo.PropertyType);
                    propertyInfo.SetValue(instance, convertedValue);
                }
            }
        }
    }
}