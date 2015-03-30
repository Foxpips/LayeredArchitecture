using System;

namespace Business.Logic.Layer.Exceptions.Generic.Args
{
    [Serializable]
    public abstract class ExceptionArgsBase
    {
        protected abstract string Message { get; }

        public override string ToString()
        {
            return Message;
        }

        public abstract void Handle();
    }
}