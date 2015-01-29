using System;

using Framework.Layer.Logging;

namespace Core.Library.Helpers
{
    public class SafeExecutionHelper
    {
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