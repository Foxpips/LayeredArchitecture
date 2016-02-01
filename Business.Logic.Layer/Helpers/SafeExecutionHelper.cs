using System;
using Business.Objects.Layer.Interfaces.Execution;
using Business.Objects.Layer.Interfaces.Logging;

namespace Business.Logic.Layer.Helpers
{
    public class SafeExecutionHelper : IExecutionHandler
    {
        private readonly ICustomLogger _logger;

        public SafeExecutionHelper(ICustomLogger logger)
        {
            _logger = logger;
        }

        /// <summary>
        /// Handle the exception manually through a func
        /// </summary>
        /// <returns>Generic value of func</returns>
        public TReturnType ExecuteSafely<TReturnType, TException>(ExceptionPolicy policy, Func<TReturnType> work, Action<TException, ICustomLogger> handle)
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

        /// <summary>
        /// Handle the exception manually through a func
        /// </summary>
        public void ExecuteSafely<TException>(ExceptionPolicy policy, Action work, Action<TException, ICustomLogger> handle)
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

        /// <summary>
        /// Simply handle the exception and log an error using the logger
        /// </summary>
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

        public TType ExecuteSafely<TType, TException>(Func<TType> work, ExceptionPolicy policy = ExceptionPolicy.RethrowException)
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