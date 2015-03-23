using System;

using Business.Logic.Layer.Interfaces.Logging;

using Framework.Layer.Logging;

namespace Core.Library.Helpers
{
    public class SafeExecutionHelper
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

        public static void Try(Action work)
        {
            try
            {
                work();
            }
            catch (Exception ex)
            {
                new CustomLogger().Log(msg => msg.Error(ex));
                throw;
            }
        }

        public static TType Try<TType>(Func<TType> work)
        {
            try
            {
                return work();
            }
            catch (Exception ex)
            {
                new CustomLogger().Log(msg => msg.Error(ex));
                throw;
            }
        }
    }
}