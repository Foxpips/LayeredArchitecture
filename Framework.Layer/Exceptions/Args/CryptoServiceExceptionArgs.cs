using System;

namespace Framework.Layer.Exceptions.Args
{
    public class CryptoServiceExceptionArgs : ExceptionArgsBase
    {
        public string Error { get; set; }

        public CryptoServiceExceptionArgs(string cryptographicError)
        {
            Error = cryptographicError;
        }

        protected override string Message
        {
            get { return "The cryptographic exception encountered was: " + Error; }
        }

        public override void Handle()
        {
            Logger.Log(log => log.Error(Message));
            Console.WriteLine(Message);
        }
    }
}