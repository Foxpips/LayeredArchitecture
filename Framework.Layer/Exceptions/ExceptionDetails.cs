using System;
using System.Reflection;

namespace Framework.Layer.Exceptions
{
    public class ExceptionDetails
    {
        public string MethodName { get; set; }
        public string MethodBody { get; set; }
        public Exception Exception { get; set; }

        public ExceptionDetails(Exception ex, MethodBase info)
        {
            var methodBody = info.GetMethodBody();
            Exception = ex;
            MethodName = info.Name;
            MethodBody = methodBody != null ? methodBody.ToString() : "undefined";
        }
    }
}