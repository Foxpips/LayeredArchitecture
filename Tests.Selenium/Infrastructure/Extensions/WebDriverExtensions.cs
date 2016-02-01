using System;
using System.Threading;
using OpenQA.Selenium;
using OpenQA.Selenium.Support.UI;

namespace Tests.Selenium.Infrastructure.Extensions
{
    public static class WebDriverExtensions
    {
        private static readonly TimeSpan FromMilliseconds = TimeSpan.FromMilliseconds(500);
        private static readonly Action Wait = () => Thread.Sleep(FromMilliseconds);

        public static void ClickWait(this IWebElement element, TimeSpan timeSpan = default(TimeSpan))
        {
            if (timeSpan == default(TimeSpan))
            {
                timeSpan = FromMilliseconds;
            }

            element.Click();
            Thread.Sleep(timeSpan);
        }

        public static void SendKeysWait(this IWebElement element, string value, TimeSpan timeSpan = default(TimeSpan))
        {
            if (timeSpan == default(TimeSpan))
            {
                timeSpan = FromMilliseconds;
            }

            element.SendKeys(value);
            Thread.Sleep(timeSpan);
        }

        public static void SelectIndexDropDown(this IWebDriver driver, By identifier, int index)
        {
            new SelectElement(driver.FindElement(identifier)).SelectByIndex(index);
            Wait();
        }

        public static void SelectTextDropDown(this IWebDriver driver, By identifier, string value)
        {
            new SelectElement(driver.FindElement(identifier)).SelectByText(value);
            Wait();
        }

        public static void SelectValueDropDown(this IWebDriver driver, By identifier, string value)
        {
            new SelectElement(driver.FindElement(identifier)).SelectByValue(value);
            Wait();
        }

        public static void ExecuteAndWait(this IWebDriver driver, Action<IWebDriver> work)
        {
            try
            {
                work(driver);
                Wait();
            }
            catch (NoSuchElementException ex)
            {
                Console.WriteLine(ex.Message);
                throw;
            }
        }
    }
}