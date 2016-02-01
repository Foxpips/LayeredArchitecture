using System;
using System.Threading;
using OpenQA.Selenium;
using OpenQA.Selenium.Support.UI;

namespace Tests.Selenium.Infrastructure.Helpers
{
    public abstract class SeleniumBase
    {
        protected IWait<IWebDriver> Pause;
        protected readonly Action Wait = () => Thread.Sleep(500);
        public IWebDriver Driver { get; set; }
    }
}