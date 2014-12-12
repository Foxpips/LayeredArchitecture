using System;

using Framework.Layer.Exceptions.Args;

namespace Framework.Layer.Exceptions
{
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