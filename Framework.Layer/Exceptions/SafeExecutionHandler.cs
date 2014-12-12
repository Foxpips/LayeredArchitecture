using System;

using Framework.Layer.Logging;

namespace Framework.Layer.Exceptions
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
    }
}