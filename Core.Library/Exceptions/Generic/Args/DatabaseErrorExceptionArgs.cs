using System;

namespace Core.Library.Exceptions.Generic.Args
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
            Logger.Error(Message);
            Console.WriteLine(Message);
        }

        protected override string Message
        {
            get { return string.Format("Error accessing Database please check logs for details. {0}", ErrorMessage); }
        }
    }
}