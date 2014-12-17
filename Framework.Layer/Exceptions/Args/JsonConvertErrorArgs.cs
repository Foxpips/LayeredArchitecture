namespace Framework.Layer.Exceptions.Args
{
    public class JsonConvertErrorArgs : ExceptionArgsBase
    {
        public string ErrorMessage { get; set; }

        public JsonConvertErrorArgs(string message)
        {
            ErrorMessage = message;
        }

        protected override string Message
        {
            get
            {
                return string.Format(
                    "Json.net deserialization error!" +
                    "\n Check logs for additional error information" +
                    "\n Exception Message: {0}", ErrorMessage);
            }
        }

        public override void Handle()
        {
        }
    }
}