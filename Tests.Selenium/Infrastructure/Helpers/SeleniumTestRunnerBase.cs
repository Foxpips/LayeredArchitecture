using System;
using System.Collections.Generic;
using Business.Logic.Layer.Extensions;
using Business.Objects.Layer.Interfaces.Execution;
using Business.Objects.Layer.Interfaces.Logging;
using NUnit.Framework;
using OpenQA.Selenium;
using OpenQA.Selenium.Support.UI;
using StructureMap.Pipeline;
using Tests.Selenium.Configuration;
using Tests.Selenium.Infrastructure.Managers;

namespace Tests.Selenium.Infrastructure.Helpers
{
    public class SeleniumTestRunnerBase : SeleniumBase, IDisposable
    {
        private ILoginManager _loginManager;
        private ICustomLogger _customLogger;
        private IExecutionHandler _safeExecutionHelper;
        private readonly IList<IWebDriver> _driverList = DriverManager.GetDriverlList();

        [SetUp]
        public void Method_Setup()
        {
            var container = new SeleniumDependencyResolver().Container;
            _customLogger = container.GetInstance<ICustomLogger>();
            _safeExecutionHelper = container.GetInstance<IExecutionHandler>();
            _loginManager = container.GetInstance<ILoginManager>();
        }

        private void InitialiseDriver(IWebDriver driver)
        {
            Driver = driver;
            Pause = new WebDriverWait(Driver, TimeSpan.FromSeconds(1));
        }

        protected virtual void RunDrivers(Action work)
        {
            _safeExecutionHelper.ExecuteSafely<WebDriverException>(() =>
            {
                _driverList.ForEach(driver =>
                {
                    InitialiseDriver(driver);

                    _loginManager.Login(driver);
                    work();
                    _loginManager.Logout();

                    driver.Close();
                });
            });
        }

        public void Dispose()
        {
            if (_safeExecutionHelper != null)
            {
                _safeExecutionHelper.Dispose();
            }
        }
    }
}