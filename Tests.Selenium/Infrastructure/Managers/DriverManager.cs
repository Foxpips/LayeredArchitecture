using System;
using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;
using System.IO;
using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using Tests.Selenium.Infrastructure.Settings;

namespace Tests.Selenium.Infrastructure.Managers
{
    public static class DriverManager
    {
        public static IList<IWebDriver> GetDriverlList()
        {
            var path = new DirectoryInfo(Directory.GetCurrentDirectory());
            if (path.Parent == null || path.Parent.Parent == null)
            {
                throw new FileNotFoundException("Could not find drivers directory!");
            }

            var driverDirectory = path.Parent.Parent.FullName + DriverSettings.Drivers;

            return new List<IWebDriver>
            {
                CreateChromeDriver(driverDirectory)
            };
        }

        private static ChromeDriver CreateChromeDriver(string driverDirectory)
        {
            var chromeDriver = new ChromeDriver(driverDirectory + DriverSettings.ChromeDriver);
            chromeDriver.Manage().Timeouts().ImplicitlyWait(TimeSpan.FromMinutes(1));
            return chromeDriver;
        }
    }
}