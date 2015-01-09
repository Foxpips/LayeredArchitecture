using System;
using System.Collections.Concurrent;
using System.Reflection;

using Common.Logging;

using Rhino.ServiceBus;
using Rhino.ServiceBus.Impl;
using Rhino.ServiceBus.Internal;
using Rhino.ServiceBus.MessageModules;

using TaskRunner.Core.Infrastructure.ServiceBus.Messages;

namespace TaskRunner.Core.Infrastructure.ServiceBus
{
    public class TrackFailedMessagesModule : IMessageModule
    {
        private static readonly ILog _logger = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
        private int _numberOfRetries;

        private readonly ConcurrentDictionary<Guid, ErrorCounter> _failureCounts =
            new ConcurrentDictionary<Guid, ErrorCounter>();

        private IServiceBus _bus;

        public void Init(ITransport transport, IServiceBus bus)
        {
            _logger.Info("Init");

            _bus = bus;

            _numberOfRetries = BusConfig.GetNumberOfRetries();

            transport.MessageArrived += TransportOnMessageArrived;
            transport.MessageProcessingCompleted += TransportOnMessageProcessingCompleted;
            transport.MessageProcessingFailure += TransportOnMessageProcessingFailure;
            transport.MessageSerializationException += TransportOnMessageSerializationException;
        }

        private void TransportOnMessageSerializationException(
            CurrentMessageInformation currentMessageInformation, Exception exception)
        {
            _logger.Error("TransportOnMessageSerializationException", exception);

            _failureCounts.AddOrUpdate(currentMessageInformation.MessageId,
                guid => new ErrorCounter(exception.ToString(), _numberOfRetries + 1),
                delegate(Guid guid, ErrorCounter counter)
                {
                    counter.FailureCount++;
                    return counter;
                });
        }

        private static bool TransportOnMessageArrived(CurrentMessageInformation currentMessageInformation)
        {
            _logger.Info("TransportOnMessageArrived");
            return false;
        }

        private void TransportOnMessageProcessingCompleted(
            CurrentMessageInformation currentMessageInformation, Exception exception)
        {
            _logger.Info("TransportOnMessageProcessingCompleted");

            if (exception == null)
            {
                ErrorCounter errorCounter;
                _failureCounts.TryRemove(currentMessageInformation.MessageId, out errorCounter);
            }
        }

        private void TransportOnMessageProcessingFailure(
            CurrentMessageInformation currentMessageInformation, Exception exception)
        {
            _logger.Error("TransportOnMessageProcessingFailure", exception);

            ErrorCounter updatedErrorCounter =
                _failureCounts.AddOrUpdate(currentMessageInformation.MessageId,
                    guid => new ErrorCounter(exception.ToString(), 1),
                    delegate(Guid guid, ErrorCounter counter)
                    {
                        counter.FailureCount++;
                        return counter;
                    });

            if (updatedErrorCounter.FailureCount >= _numberOfRetries)
            {
                ErrorCounter errCounter;
                if (_failureCounts.TryRemove(currentMessageInformation.MessageId, out errCounter))
                {
                    _bus.SendToSelfNoThrow(new FailedToProcessMessageEvent(currentMessageInformation.TransportMessageId,
                        currentMessageInformation.Message, updatedErrorCounter.ExceptionText));
                }
            }
        }

        public void Stop(ITransport transport, IServiceBus bus)
        {
            _logger.Info("Stop");
            transport.MessageArrived -= TransportOnMessageArrived;
            transport.MessageProcessingCompleted -= TransportOnMessageProcessingCompleted;
            transport.MessageProcessingFailure -= TransportOnMessageProcessingFailure;
        }

        private class ErrorCounter
        {
            public ErrorCounter(string exceptionText, int failureCount)
            {
                ExceptionText = exceptionText;
                FailureCount = failureCount;
            }

            public string ExceptionText { get; private set; }
            public int FailureCount { get; set; }
        }
    }
}