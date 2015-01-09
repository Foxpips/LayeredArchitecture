using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Reflection;

namespace TaskRunner.Core.Infrastructure.Aop
{
    public class FilterProvider
    {
        public IDictionary<string, object> GetMessagePropertyValues<TMessage>(TMessage message)
        {
            var propertyValues = new Dictionary<string, object>(StringComparer.OrdinalIgnoreCase);

            PropertyInfo[] properties =
                typeof (TMessage).GetProperties(BindingFlags.Instance | BindingFlags.Public | BindingFlags.NonPublic);
            foreach (PropertyInfo propertyInfo in properties)
            {
                propertyValues.Add(propertyInfo.Name, propertyInfo.GetValue(message, null));
            }

            return propertyValues;
        }

        public IEnumerable<IActionFilter> GetFiltersForMethod<T, TV>(object obj, Expression<Func<T, Action<TV>>> method)
        {
            string methodName = GetMethodInfo(method).Name;

            MethodInfo methodInfo = obj.GetType()
                .GetMethod(methodName, BindingFlags.Instance | BindingFlags.Public | BindingFlags.NonPublic);

            IEnumerable<IActionFilter> filters =
                methodInfo.GetCustomAttributes(typeof (IActionFilter), true).Cast<IActionFilter>();

            return filters;
        }

        private static MemberInfo GetMethodInfo<T, TV>(Expression<Func<T, Action<TV>>> expression)
        {
            var unaryExpression = (UnaryExpression) expression.Body;
            var methodCallExpression = (MethodCallExpression) unaryExpression.Operand;
            var methodInfoExpression = (ConstantExpression) methodCallExpression.Arguments.Last();
            var methodInfo = (MemberInfo) methodInfoExpression.Value;

            return methodInfo;
        }
    }
}