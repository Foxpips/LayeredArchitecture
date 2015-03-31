using System;

namespace Business.Objects.Layer.Exceptions.Generic.Args
{
    public class ResolveSafeExecutionHelperTestExceptionArgs : ExceptionArgsBase
    {
        protected override string Message
        {
            get { return "Test Message"; }
        }

        public override void Handle()
        {
            Console.WriteLine("Test Handle");
        }
    }
}