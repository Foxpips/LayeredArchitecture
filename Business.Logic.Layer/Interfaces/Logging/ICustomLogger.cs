namespace Business.Logic.Layer.Interfaces.Logging
{
    public interface ICustomLogger
    {
        void Info(object message);
        void Debug(object message);
        void Error(object message);
        void Fatal(object message);
        void Warn(object message);
    }
}