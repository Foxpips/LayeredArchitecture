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

        public abstract void Handle();

        public override string ToString()
        {
            return Message;
        }
    }
}