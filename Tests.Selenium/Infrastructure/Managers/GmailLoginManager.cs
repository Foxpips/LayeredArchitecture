using System;
using Business.Objects.Layer.Interfaces.Execution;
using Business.Objects.Layer.Interfaces.Logging;
using OpenQA.Selenium;
using OpenQA.Selenium.Support.UI;
using Tests.Selenium.Infrastructure.Extensions;
using Tests.Selenium.Infrastructure.Helpers;

namespace Tests.Selenium.Infrastructure.Managers
{
    public class GmailLoginManager : SeleniumBase, ILoginManager
    {
        private readonly ICustomLogger _logger;
        private readonly IExecutionHandler _executionHandler;

        public GmailLoginManager(ICustomLogger logger, IExecutionHandler safExecutionHandler)
        {
            _executionHandler = safExecutionHandler;
            _logger = logger;
        }

        public void Login(IWebDriver driver)
        {
            _executionHandler.ExecuteSafely<WebDriverException>(() =>
            {
                Driver = driver;
                Pause = new WebDriverWait(driver, TimeSpan.FromSeconds(5));

                Driver.Navigate().GoToUrl("https://www.google.ie");
                Wait();

                Pause.Until(x => x.FindElement(By.LinkText("Gmail")));
                Driver.FindElement(By.LinkText("Gmail")).ClickWait();

                _logger.Debug("logged in successfully");
            });
        }

        public void Logout()
        {
            //            Driver.Navigate().GoToUrl("");
            //            Wait();
            //
            //            Pause.Until(x => x.FindElement(By.Id("")));
            //            Driver.FindElement(By.Id("")).SendKeys("");
            //            Driver.FindElement(By.Id("")).SendKeys("");
            //
            //            Driver.FindElement(By.Id("")).ClickWait();

            _logger.Debug("logged out successfully");
        }
    }
}