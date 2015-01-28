using System;

using Framework.Layer.Logging;

namespace Core.Library.Exceptions.Generic.Args
{
    [Serializable]
    public abstract class ExceptionArgsBase
    {
        protected CustomLogger Logger { get; set; }

        protected ExceptionArgsBase()
        {
            Logger = new CustomLogger();
        }

        protected abstract string Message { get; }

        public override string ToString()
        {
            return Message;
        }

        public abstract void Handle();
    }
}