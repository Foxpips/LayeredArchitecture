﻿namespace TaskRunner.Common.Messages
{
    public class FailedToProcessMessageEvent
    {
        public string MessageId { get; set; }
        public object Message { get; set; }
        public string ExceptionText { get; set; }

        public FailedToProcessMessageEvent()
        {
        }

        public FailedToProcessMessageEvent(string messageId, object message, string exceptionText)
        {
            MessageId = messageId;
            Message = message;
            ExceptionText = exceptionText;
        }
    }
}