//using log4net;

using System;
using System.Messaging;
using System.Reflection;

using Common.Logging;

using Rhino.ServiceBus;
using Rhino.ServiceBus.Msmq;

namespace TaskRunner.Core.Infrastructure.Configuration
{
    public static class PrepareQueues
    {
        private static readonly ILog _logger = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        private static void EnsureQueueExists(string queuePath)
        {
            if (!MessageQueue.Exists(queuePath))
            {
                _logger.FatalFormat("Queue {0} doesn't exist!", queuePath);
                throw new InvalidOperationException(string.Format("Queue {0} doesn't exist!", queuePath));
            }
        }

        public static void CreateQueueIfNotExists(string queuePath)
        {
            if (!MessageQueue.Exists(queuePath))
            {
                _logger.Info("Createing queue...");
                MessageQueue.Create(queuePath, true);
                _logger.Info("Queue created.");
            }
            else
            {
                _logger.Info("Existing queue, nothing to do.");
            }
        }

        private static void PurgeQueue(string queuePath)
        {
            using (var queue = new MessageQueue(queuePath))
            {
                queue.Purge();
            }
        }

        private static void PurgeSubqueues(string queuePath, QueueType queueType)
        {
            switch (queueType)
            {
                case QueueType.Standard:
                    PurgeSubqueue(queuePath, "errors");
                    PurgeSubqueue(queuePath, "discarded");
                    PurgeSubqueue(queuePath, "timeout");
                    PurgeSubqueue(queuePath, "subscriptions");
                    break;
                case QueueType.LoadBalancer:
                    PurgeSubqueue(queuePath, "endpoints");
                    PurgeSubqueue(queuePath, "workers");
                    break;
                default:
                    throw new ArgumentOutOfRangeException("queueType", "Can't handle queue type: " + queueType);
            }
        }

        private static void PurgeSubqueue(string queuePath, string subqueueName)
        {
            using (var queue = new MessageQueue(queuePath + ";" + subqueueName))
            {
                queue.Purge();
            }
        }

        public static void Prepare(string queueName, QueueType queueType)
        {
            _logger.InfoFormat("Prepairing queue {0}...", queueName);

            var queueUri = new Uri(queueName);
            var endpoint = new Endpoint {Uri = queueUri};

            QueueInfo queueInfo = MsmqUtil.GetQueuePath(endpoint);
            CreateQueueIfNotExists(queueInfo.QueuePath);
            EnsureQueueExists(queueInfo.QueuePath);

            /*NOTE:
            If a queue is created this way by a windows service it wont yield the correct permissions
            for other accounts i.e admin, developer to access this queue.*/
//            CreateQueueIfNotExists(queuePath.QueuePath);
//            PurgeQueue(queuePath.QueuePath);
//            PurgeSubqueues(queuePath.QueuePath, queueType);
        }
    }
}