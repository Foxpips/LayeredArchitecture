using System;
using System.Xml;

namespace Business.Logic.Layer.Exceptions.Basic
{
    public class ApiSoapException : Exception
    {
        public ApiSoapException(string message, XmlQualifiedName xmlQualifiedName, Exception innerException)
        {
        }
    }
}