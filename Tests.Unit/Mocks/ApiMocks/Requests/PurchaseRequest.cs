﻿using System;

namespace Tests.Unit.Mocks.ApiMocks.Requests
{
    public class PurchaseRequest : IServiceRequest
    {
        public string UserName { get; set; }
        public string Password { get; set; }

        public string ReturnThirdPartyResponse()
        {
            throw new Exception("Api Exception");
            return "Success";
        }
    }
}