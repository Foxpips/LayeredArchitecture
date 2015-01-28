using System;

using Framework.Layer.Logging;

namespace Framework.Layer.Handlers
{
    public class SafeExecutionHandler
    {
        public static void Try(Action work)
        {
            try
            {
                work();
            }
            catch (Exception ex)
            {
                new CustomLogger().Log(log => log.Error(ex));
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
                new CustomLogger().Log(log => log.Error(ex));
                throw;
            }
        }
    }
}