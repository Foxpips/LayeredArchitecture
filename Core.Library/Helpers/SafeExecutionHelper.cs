using System;

using Business.Logic.Layer.Interfaces.Logging;

using StructureMap;

namespace Core.Library.Helpers
{
    public static class SafeExecutionHelper
    {
        private static readonly ICustomLogger _customLogger;

        static SafeExecutionHelper()
        {
            _customLogger = ObjectFactory.Container.GetInstance<ICustomLogger>();
        }

        public static TType ExecuteSafely<TType, TException>(Func<TType> work)
            where TException : Exception
        {
            try
            {
                return work();
            }
            catch (TException ex)
            {
                _customLogger.Error(ex.Message);
            }

            return default(TType);
        }

        public static void ExecuteSafely<TException>(Action work)
            where TException : Exception
        {
            try
            {
                work();
            }
            catch (TException ex)
            {
                _customLogger.Error(ex.Message);
            }
        }
    }
}