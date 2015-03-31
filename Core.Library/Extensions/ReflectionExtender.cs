using System;
using System.Linq;

using Business.Objects.Layer.Pocos.Reflection;

namespace Business.Logic.Layer.Extensions
{
    public static class ReflectionExtender
    {
        public static object SetPublicProperties(this object instance, PropertyWithValue[] props)
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
            return instance;
        }
    }
}