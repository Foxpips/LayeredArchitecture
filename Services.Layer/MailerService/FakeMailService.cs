using System;

namespace Service.Layer.MailerService
{
    public class FakeMailService : IMailService
    {
        public void SendMail(string to, string @from, string subject, string content)
        {
        }

        public void SendMail(
            int emailFormat, string bcc, string cc, string content, string subject, string @from, string to)
        {
            Console.WriteLine("subject {0}", subject);
            Console.WriteLine("content {0}", content);
        }

        public void SendEmailToCustomer(int orderRef, MailType eMails, bool includeLinkedOrders)
        {
            Console.WriteLine("OrderRef: {0}", orderRef);
            Console.WriteLine("EmailType: {0}", eMails);
            Console.WriteLine("includeLinkedOrders: {0}", includeLinkedOrders);
        }
    }
}