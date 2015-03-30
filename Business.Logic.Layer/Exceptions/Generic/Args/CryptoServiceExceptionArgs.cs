using System;

namespace Business.Logic.Layer.Exceptions.Generic.Args
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
            Console.WriteLine(Message);
        }
    }
}