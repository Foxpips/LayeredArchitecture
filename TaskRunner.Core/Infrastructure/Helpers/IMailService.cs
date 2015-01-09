namespace TaskRunner.Core.Infrastructure.Helpers
{
    public interface IMailService
    {
        void SendMail(
            int emailFormat, string bcc, string cc, string content, string subject, string from, string to);
    }
}