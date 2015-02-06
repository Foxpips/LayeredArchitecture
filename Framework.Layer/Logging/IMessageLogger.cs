namespace Framework.Layer.Logging
{
    public interface IMessageLogger
    {
        void Info(object message);
        void Debug(object message);
        void Error(object message);
        void Fatal(object message);
        void Warn(object message);
    }
}