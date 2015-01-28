using System;
using System.Xml;

namespace Core.Library.Exceptions.Basic
{
    public class ApiException : Exception
    {
        public ApiException(string message, XmlQualifiedName xmlQualifiedName, Exception innerException)
        {
        }
    }
}