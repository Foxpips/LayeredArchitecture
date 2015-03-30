using System;

using Business.Logic.Layer.Interfaces.Logging;

namespace Core.Library.Helpers
{
    public static class SafeExecutionHelper
    {
        public static TType ExecuteSafely<TType, TException>(ICustomLogger logger, Func<TType> work)
            where TException : Exception
        {
            try
            {
                return work();
            }
            catch (TException ex)
            {
                logger.Error(ex.Message);
            }

            return default(TType);
        }

        public static void ExecuteSafely<TException>(ICustomLogger logger, Action work)
            where TException : Exception
        {
            try
            {
                work();
            }
            catch (TException ex)
            {
                logger.Error(ex.Message);
            }
        }
    }
}