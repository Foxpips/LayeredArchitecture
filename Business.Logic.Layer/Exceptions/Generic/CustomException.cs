using System;

using Business.Objects.Layer.Exceptions.Generic.Args;

namespace Business.Objects.Layer.Exceptions.Generic
{
    [Serializable]
    public class CustomException<TExceptionArgs> : Exception where TExceptionArgs : ExceptionArgsBase
    {
        private readonly TExceptionArgs _args;

        public CustomException(TExceptionArgs args)
        {
            _args = args;
        }

        public TExceptionArgs Args
        {
            get { return _args; }
        }
    }
}