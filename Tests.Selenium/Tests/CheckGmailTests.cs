using System;
using NUnit.Framework;
using Tests.Selenium.Infrastructure.Helpers;

namespace Tests.Selenium.Tests
{
    public class CheckGmailTests : SeleniumTestRunnerBase
    {
        [Test]
        public void Login_Gmail_Success()
        {
            RunDrivers(() => { 
                //TODO: Simon Markey
            });
        }
    }
}