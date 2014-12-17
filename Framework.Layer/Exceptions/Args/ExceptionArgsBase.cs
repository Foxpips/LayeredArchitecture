using System;

namespace Framework.Layer.Exceptions.Args
{
    [Serializable]
    public abstract class ExceptionArgsBase
    {
        protected virtual string Message
        {
            get { return string.Empty; }
        }

        public override string ToString()
        {
            return Message;
        }

        public abstract void Handle();
    }
}