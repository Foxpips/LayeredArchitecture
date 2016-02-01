using System;
using Business.Objects.Layer.Interfaces.Logging;

namespace Business.Objects.Layer.Interfaces.Execution
{
    public enum ExceptionPolicy
    {
        RethrowException,
        SwallowException
    }

    public interface IExecutionHandler : IDisposable
    {
        void ExecuteSafely<TException>(ExceptionPolicy policy, Action work,
            Action<TException, ICustomLogger> handle) where TException : Exception;

        void ExecuteSafely<TException>(Action work, ExceptionPolicy policy = ExceptionPolicy.RethrowException)
            where TException : Exception;
    }
}