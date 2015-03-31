using System;
using System.Xml;

namespace Business.Objects.Layer.Exceptions.Basic
{
    public class ApiException : Exception
    {
        public ApiException(string message, XmlQualifiedName xmlQualifiedName, Exception innerException)
        {
        }
    }
}