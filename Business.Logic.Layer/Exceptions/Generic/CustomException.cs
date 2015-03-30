using System;

using Business.Logic.Layer.Exceptions.Generic.Args;

namespace Business.Logic.Layer.Exceptions.Generic
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