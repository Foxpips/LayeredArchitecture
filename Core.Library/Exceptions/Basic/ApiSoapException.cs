using System;
using System.Xml;

namespace Core.Library.Exceptions.Basic
{
    public class ApiSoapException : Exception
    {
        public ApiSoapException(string message, XmlQualifiedName xmlQualifiedName, Exception innerException)
        {
        }
    }
}