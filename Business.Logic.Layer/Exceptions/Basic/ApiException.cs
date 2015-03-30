using System;
using System.Xml;

namespace Business.Logic.Layer.Exceptions.Basic
{
    public class ApiException : Exception
    {
        public ApiException(string message, XmlQualifiedName xmlQualifiedName, Exception innerException)
        {
        }
    }
}