﻿using System;
using System.Web.Mvc;
using System.Web.Routing;
using System.Web.SessionState;

using Business.Logic.Layer.Helpers.Reflector;
using Business.Logic.Layer.Managers.ServiceBus;
using Business.Objects.Layer.Interfaces.Logging;

using Dependency.Resolver.Loaders;

using Rhino.ServiceBus;

using SqlAgentUIRunner.Controllers;

using TaskRunner.Core.ServiceBus;

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
                    container.GetInstance<ICustomLogger>(), new Client<IOnewayBus>(container));
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