using System;
using OpenQA.Selenium;
using OpenQA.Selenium.Support.UI;

namespace Tests.Selenium.Infrastructure.Extensions
{
    public static class WebElementExtensions
    {
        public static bool PollExists(this IWebDriver driver, By by, TimeSpan time = default(TimeSpan))
        {
            var present = false;

            if (time == default(TimeSpan))
            {
                time = TimeSpan.FromSeconds(5);
            }

            driver.Manage().Timeouts().ImplicitlyWait(time);

            try
            {
                present = driver.FindElement(by).Displayed;
            }
            catch (NoSuchElementException ex)
            {
                Console.WriteLine(ex.Message);
            }

            return present;
        }

        public static SelectElement GetSelectElement(this IWebDriver driver, By by)
        {
            return new SelectElement(driver.GetElement(by));
        }

        public static IWebElement GetElement(this IWebDriver driver, By by)
        {
            for (var i = 1; i <= 5; i++)
            {
                try
                {
                    return driver.FindElement(by);
                }
                catch (Exception e)
                {
                    Console.WriteLine("Exception was raised on locating element: " + e.Message);
                }
            }
            throw new ElementNotVisibleException(by.ToString());
        }
    }
}