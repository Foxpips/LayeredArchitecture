using System;
using System.Configuration;
using System.IO;
using System.Reflection;

using Common.Logging;

using Rhino.ServiceBus;
using Rhino.ServiceBus.Internal;

using Service.Layer.MailerService;

using StructureMap;

namespace TaskRunner.Core.Infrastructure.Extenders
{
    public static class ServiceBusExtender
    {
        private static readonly ILog _logger = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        public static void SendToSelfNoThrow(this IServiceBus bus, params object[] messages)
        {
            try
            {
                bus.SendToSelf(messages);
            }
            catch (Exception oops)
            {
                HandleException(oops, messages);
            }
        }

        private static void HandleException(Exception oops, object[] messages)
        {
            _logger.Error("Failed to send message to the bus.", oops);

            string xmlContent = SerializeMessages(messages);
            _logger.Error(xmlContent);

            string content =
                string.Format(
                    "Failed to send message to the bus. {0}Please check the TaskRunner log files.{0}{0}Machine: {1}",
                    Environment.NewLine, Environment.MachineName);
            string subject = string.Format("Failed to send message to the bus.");

            var mailService = ObjectFactory.GetInstance<IMailService>();

            mailService.SendMail(0, string.Empty, string.Empty,
                content,
                subject,
                ConfigurationManager.AppSettings["ErrorsEmailSender"],
                ConfigurationManager.AppSettings["ErrorsEmailRecipient"]);
        }

        private static string SerializeMessages(object[] messages)
        {
            var messageSerializer = ObjectFactory.GetInstance<IMessageSerializer>();
            using (Stream stream = new MemoryStream())
            {
                messageSerializer.Serialize(messages, stream);
                stream.Position = 0;

                using (var reader = new StreamReader(stream))
                {
                    string xmlContent = reader.ReadToEnd();
                    return xmlContent;
                }
            }
        }
    }
}