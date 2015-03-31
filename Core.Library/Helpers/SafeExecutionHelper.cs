using System;

using Business.Objects.Layer.Interfaces.Logging;

namespace Business.Logic.Layer.Helpers
{
    public enum ExceptionPolicy
    {
        RethrowException,
        SwallowException
    }

    public class SafeExecutionHelper : IDisposable
    {
        private readonly ICustomLogger _logger;

        public SafeExecutionHelper(ICustomLogger logger)
        {
            _logger = logger;
        }

        public TReturnType ExecuteSafely<TReturnType, TException>(
            ExceptionPolicy policy, Func<TReturnType> work, Action<TException, ICustomLogger> handle)
            where TException : Exception
        {
            try
            {
                return work();
            }
            catch (TException ex)
            {
                handle(ex, _logger);
                if (policy.Equals(ExceptionPolicy.RethrowException))
                {
                    throw;
                }

                return default(TReturnType);
            }
        }

        public void ExecuteSafely<TException>(
            ExceptionPolicy policy, Action work, Action<TException, ICustomLogger> handle)
            where TException : Exception
        {
            try
            {
                work();
            }
            catch (TException ex)
            {
                handle(ex, _logger);

                if (policy.Equals(ExceptionPolicy.RethrowException))
                {
                    throw;
                }
            }
        }

        public void ExecuteSafely<TException>(Action work, ExceptionPolicy policy = ExceptionPolicy.RethrowException)
            where TException : Exception
        {
            try
            {
                work();
            }
            catch (TException ex)
            {
                _logger.Error(ex.Message);

                if (policy.Equals(ExceptionPolicy.RethrowException))
                {
                    throw;
                }
            }
        }

        public TType ExecuteSafely<TType, TException>(
            Func<TType> work, ExceptionPolicy policy = ExceptionPolicy.RethrowException)
            where TException : Exception
        {
            try
            {
                return work();
            }
            catch (TException ex)
            {
                _logger.Error(ex.Message);

                if (policy.Equals(ExceptionPolicy.RethrowException))
                {
                    throw;
                }
            }
            return default(TType);
        }

        public void Dispose()
        {
            _logger.Dispose();
        }
    }
}