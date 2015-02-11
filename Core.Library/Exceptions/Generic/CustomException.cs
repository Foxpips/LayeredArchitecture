using System;

using Core.Library.Exceptions.Generic.Args;

namespace Core.Library.Exceptions.Generic
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