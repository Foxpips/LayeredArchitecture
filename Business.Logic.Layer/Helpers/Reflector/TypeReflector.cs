using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using Business.Logic.Layer.Extensions;

namespace Business.Logic.Layer.Helpers.Reflector
{
    public class TypeReflector
    {
        public void GetPropertiesWithAttributes(string strType, List<Type> attributesToFind)
        {
            var currentType = Assembly.GetExecutingAssembly().ExportedTypes.FirstOrDefault(x => x.Name.Equals(strType));

            if (currentType == null)
            {
                throw new TypeLoadException("Type not found: " + strType);
            }

            var propertyInfos = currentType.GetProperties();
            var displayProps = propertyInfos.Where(x => GetCustomAttributes(x, attributesToFind).Any());

            displayProps.ForEach(Console.WriteLine);
        }

        private static IEnumerable<CustomAttributeData> GetCustomAttributes(MemberInfo x, ICollection<Type> types)
        {
            var customAttributeDatas = x.CustomAttributes.Where(attr => types.Contains(attr.AttributeType));
            return customAttributeDatas;
        }
    }
}