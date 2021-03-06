﻿using System;
using System.Xml;

using Business.Logic.Layer.Utilities.WebApi;
using Business.Objects.Layer.Exceptions.Basic;
using Business.Objects.Layer.Interfaces.Logging;

namespace Tests.Unit.Business.Logic.Layer.Tests.UtilitiesTests
{
    public class SafeWebServiceTests : SafeWebService
    {
        public SafeWebServiceTests(ICustomLogger logger) : base(logger)
        {
        }

        public bool SafeWebServiceExecute()
        {
            var s = false;

            Execute(() => s = true);
            return s;
        }

        public void SafeWebServiceThrowApiSoapException()
        {
            Execute<object>(() => { throw new ApiSoapException("Error", new XmlQualifiedName(), new Exception()); });
        }

        public void SafeWebServiceThrowApiException()
        {
            Execute<object>(() => { throw new ApiException("Error", new XmlQualifiedName(), new Exception()); });
        }

        public void SafeWebServiceThrowException()
        {
            Execute<object>(() => { throw new Exception("Error"); });
        }
    }
}