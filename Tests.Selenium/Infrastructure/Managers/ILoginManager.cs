using OpenQA.Selenium;

namespace Tests.Selenium.Infrastructure.Managers
{
    public interface ILoginManager
    {
        void Login(IWebDriver driver);
        void Logout();
    }
}