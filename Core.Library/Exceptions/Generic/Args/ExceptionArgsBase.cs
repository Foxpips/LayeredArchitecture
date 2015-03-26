using System;

using Business.Logic.Layer.Interfaces.Logging;

using Dependency.Resolver.Loaders;

namespace Core.Library.Exceptions.Generic.Args
{
    [Serializable]
    public abstract class ExceptionArgsBase
    {
        protected ICustomLogger Logger { get; set; }

        protected ExceptionArgsBase()
        {
            Logger = new DependencyManager().ConfigureStartupDependencies().GetInstance<ICustomLogger>();
        }

        protected abstract string Message { get; }

        public override string ToString()
        {
            return Message;
        }

        public abstract void Handle();
    }
}