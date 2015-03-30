using System;
using System.Web.Mvc;
using System.Web.Routing;
using System.Web.SessionState;

using Business.Logic.Layer.Interfaces.Logging;

using Core.Library.Helpers.Reflector;
using Core.Library.Managers.ServiceBus;

using Dependency.Resolver.Loaders;

using Rhino.ServiceBus;

using SqlAgentUIRunner.Controllers;

namespace SqlAgentUIRunner.Infrastructure.Factories
{
    public class CustomControllerFactory : IControllerFactory
    {
        public IController CreateController(RequestContext requestContext, string controllerName)
        {
            if (controllerName.ToUpper().StartsWith("MessageBus".ToUpper()))
            {
                var container = new DependencyManager().ConfigureStartupDependencies();

                var controller = new MessageBusController(new ServiceBusMessageManager(new TaskRunnerReflector(),
                    @"c:\Users\smarkey\Documents\GitHub\LayeredArchitecture\TaskRunner.Common\bin\Debug\TaskRunner.Common.dll"),
                    container.GetInstance<ICustomLogger>(), container.GetInstance<IOnewayBus>());
                return controller;
            }
            return new DefaultControllerFactory().CreateController(requestContext, controllerName);
        }

        public SessionStateBehavior GetControllerSessionBehavior(RequestContext requestContext, string controllerName)
        {
            return SessionStateBehavior.Default;
        }

        public void ReleaseController(IController controller)
        {
            var disposable = controller as IDisposable;

            if (disposable != null)
            {
                disposable.Dispose();
            }
        }
    }
}