using System;
using System.Linq;
using System.Reflection;
using Business.Objects.Layer.Pocos.Reflection;

namespace Business.Logic.Layer.Extensions
{
    public static class ReflectionExtender
    {
        public static object SetPublicProperties(this object instance, PropertyWithValue[] props)
        {
            instance.GetType().GetProperties().ForEach(propertyInfo =>
            {
                props.Where(prop => propertyInfo.Name.Equals(prop.Name)).ForEach(prop =>
                {
                    var convertedValue = Convert.ChangeType(prop.Value, propertyInfo.PropertyType);
                    propertyInfo.SetValue(instance, convertedValue);
                });
            });
            return instance;
        }

        public static object SetPropertyInfos(this object instance, object old, PropertyInfo[] props)
        {
            instance.GetType().GetProperties().ForEach(propertyInfo =>
            {
                props.Where(prop => propertyInfo.Name.Equals(prop.Name)).ForEach(prop =>
                {
                    var convertedValue = Convert.ChangeType(prop.GetValue(old), propertyInfo.PropertyType);
                    propertyInfo.SetValue(instance, convertedValue);
                });
            });
            return instance;
        }
    }
}