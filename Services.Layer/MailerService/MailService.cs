using System;
using System.Configuration;
using System.Net.Mail;

namespace Service.Layer.MailerService
{
    public class MailService : IMailService
    {
      public void SendMail(int emailFormat, string bcc, string cc, string content, string subject, string @from, string to)
        {
            if (string.IsNullOrEmpty(from) || string.IsNullOrEmpty(to))
            {
                throw new ArgumentException("From or To must not be null or empty");
            }

            using (var mailMessage = new MailMessage())
            {
                mailMessage.To.Add(to.Replace(';', ','));
                mailMessage.From = new MailAddress(from);
                mailMessage.Subject = subject;
                mailMessage.IsBodyHtml = emailFormat != 0;
                mailMessage.Body = content;

                if (!string.IsNullOrEmpty(cc))
                {
                    mailMessage.CC.Add(cc.Replace(';', ','));
                }

                if (!string.IsNullOrEmpty(bcc))
                {
                    mailMessage.Bcc.Add(bcc.Replace(';', ','));
                }

                using (var smtpClient = new SmtpClient(ConfigurationManager.AppSettings["SmtpClient"]))
                {
                    smtpClient.Host = smtpClient.Host;
                    smtpClient.Send(mailMessage);
                }
            }
           
        }
    }
}