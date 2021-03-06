﻿using System;

namespace Business.Objects.Layer.Exceptions.Generic.Args
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
            Console.WriteLine(Message);
        }

        protected override string Message
        {
            get { return string.Format("Error accessing Database please check logs for details. {0}", ErrorMessage); }
        }
    }
}