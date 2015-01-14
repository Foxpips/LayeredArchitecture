using System;

using Framework.Layer.Logging;

namespace Framework.Layer.Exceptions.Args
{
    public class DatabaseErrorExceptionArgs : ExceptionArgsBase
    {
        public string ErrorMessage { get; set; }

        public DatabaseErrorExceptionArgs(string exceptionMessage)
        {
            ErrorMessage = exceptionMessage;
        }

        public override void Handle()
        {
            new CustomLogger().Log(log => log.Error(Message));
            Console.WriteLine(Message);
        }

        protected override string Message
        {
            get { return string.Format("Error accessing Database please check logs for details. {0}", ErrorMessage); }
        }
    }
}